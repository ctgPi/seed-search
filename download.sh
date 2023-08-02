increment=0x0001
handle=0x0020

for((i=32;i<=311;i++))
do
   UNIVERSE_BLOCK="$(echo "$handle" | cut -c 3-)"
   handle=$(($handle + $increment))
   handle=$(printf '%#06x' $handle) 
   echo "Downloading: universe-$UNIVERSE_BLOCK.bin"
   curl "http://space-exploration-at-home.s3-website-ap-northeast-1.amazonaws.com/seed-finder/0.6.109/universe-$UNIVERSE_BLOCK.bin" --output "./downloads/universe-$UNIVERSE_BLOCK.bin"
done