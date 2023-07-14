/*
 * Copyright (c) 2010 Nicolas George
 * Copyright (c) 2011 Stefano Sabatini
 * Copyright (c) 2014 Andrey Utkin
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
 * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#include <assert.h>
#include <inttypes.h>
#include <math.h>

#include <lua5.2/lua.h>
#include <lua5.2/lualib.h>
#include <lua5.2/lauxlib.h>

#include <libavcodec/avcodec.h>
#include <libavformat/avformat.h>

typedef struct buffer_t {
    const char *data;
    size_t size;
    size_t position;
} buffer_t;

int buffer_read(void *opaque, uint8_t *buf, int buf_size) {
    buffer_t *buffer = opaque;

    size_t bytes_read;
    if (buffer->size - buffer->position > (size_t) buf_size) {
        bytes_read = (size_t) buf_size;
    } else {
        bytes_read = buffer->size - buffer->position;
    }
    if (bytes_read == 0) { return AVERROR_EOF; }

    memcpy(buf, buffer->data + buffer->position, bytes_read * sizeof(char));
    buffer->position += bytes_read;
    return bytes_read;
}

static int ogg_to_mp3(lua_State *L) {
    buffer_t ogg_buffer;
    ogg_buffer.data = lua_tolstring(L, 1, &ogg_buffer.size);
    ogg_buffer.position = 0;

    const AVCodec *decoder = avcodec_find_decoder(AV_CODEC_ID_VORBIS);
    const AVCodec *encoder = avcodec_find_encoder(AV_CODEC_ID_MP3);

    assert(decoder != NULL);
    assert(encoder != NULL);

    static AVFormatContext *ifmt_ctx;
    static AVFormatContext *ofmt_ctx;

    AVCodecContext *dec_ctx;
    AVCodecContext *enc_ctx;

    dec_ctx = avcodec_alloc_context3(decoder);
    enc_ctx = avcodec_alloc_context3(encoder);

    assert(dec_ctx != NULL);
    assert(enc_ctx != NULL);

    ifmt_ctx = avformat_alloc_context();
    assert(ifmt_ctx != NULL);

    size_t io_buf_size = 1 << 12;
    unsigned char *io_buf = av_malloc(io_buf_size * sizeof(unsigned char));
    assert(io_buf != NULL);

    AVIOContext *io_ctx = avio_alloc_context(io_buf, io_buf_size, 0, &ogg_buffer, buffer_read, NULL, NULL);
    assert(io_ctx != NULL);
    ifmt_ctx->pb = io_ctx;
    assert(avformat_open_input(&ifmt_ctx, "source.ogg", NULL, NULL) >= 0);
    assert(avformat_find_stream_info(ifmt_ctx, NULL) >= 0);
    assert(ifmt_ctx->nb_streams == 1);

    assert(avcodec_parameters_to_context(dec_ctx, ifmt_ctx->streams[0]->codecpar) >= 0);
    assert(avcodec_open2(dec_ctx, decoder, NULL) >= 0);

    enc_ctx->sample_rate = dec_ctx->sample_rate;
    enc_ctx->channel_layout = dec_ctx->channel_layout;
    enc_ctx->channels = dec_ctx->channels;
    enc_ctx->sample_fmt = dec_ctx->sample_fmt;
    enc_ctx->time_base = dec_ctx->time_base;

    assert(avcodec_open2(enc_ctx, encoder, NULL) >= 0);

    avformat_alloc_output_context2(&ofmt_ctx, NULL, NULL, "output.mp3");
    assert(ofmt_ctx != NULL);
    AVStream *out_stream = avformat_new_stream(ofmt_ctx, NULL);
    assert(out_stream != NULL);
    assert(avcodec_parameters_from_context(out_stream->codecpar, enc_ctx) >= 0);
    out_stream->time_base = enc_ctx->time_base;

    assert(avio_open_dyn_buf(&ofmt_ctx->pb) >= 0);

    {
        assert(avformat_write_header(ofmt_ctx, NULL) >= 0);

        AVPacket *dec_pkt = av_packet_alloc();
        AVFrame *frame    = av_frame_alloc();
        AVPacket *enc_pkt = av_packet_alloc();


        assert(dec_pkt != NULL);
        assert(frame   != NULL);
        assert(enc_pkt != NULL);

        /* read all packets */
        while (av_read_frame(ifmt_ctx, dec_pkt) >= 0) {
            assert(avcodec_send_packet(dec_ctx, dec_pkt) >= 0);

            while (avcodec_receive_frame(dec_ctx, frame) >= 0) {
                assert(avcodec_send_frame(enc_ctx, frame) >= 0);
                while (avcodec_receive_packet(enc_ctx, enc_pkt) >= 0) {
                    assert(av_interleaved_write_frame(ofmt_ctx, enc_pkt) >= 0);
                }
            }
        }

        /* flush encoder */
        assert(avcodec_send_frame(enc_ctx, NULL) >= 0);
        while (avcodec_receive_packet(enc_ctx, enc_pkt) >= 0) {
            assert(av_interleaved_write_frame(ofmt_ctx, enc_pkt) >= 0);
        }

        av_write_trailer(ofmt_ctx);

        av_packet_free(&enc_pkt);
        av_frame_free(&frame);
        av_packet_free(&dec_pkt);
    }

    {
        const char *mp3_data; size_t mp3_size;
        mp3_size = avio_get_dyn_buf(ofmt_ctx->pb, (uint8_t **) &mp3_data);
        lua_pushlstring(L, mp3_data, mp3_size);
    }

    {
        char *p;
        (void) avio_close_dyn_buf(ofmt_ctx->pb, (uint8_t **) &p);
        av_free(p);
    }
    avformat_free_context(ofmt_ctx);
    av_free(io_ctx->buffer);
    av_free(io_ctx);
    avformat_free_context(ifmt_ctx);

    avcodec_free_context(&enc_ctx);
    avcodec_free_context(&dec_ctx);

    return 1;
}

static const luaL_Reg libav[] = {
    {"ogg_to_mp3", ogg_to_mp3},
    {NULL, NULL},
};

int luaopen_libav(lua_State *L) {
    luaL_newlib(L, libav);
    return 1;
}
