# Running the seed finder

## Windows

    run.bat

Reach out to @ctgPi in the [SE Discord](https://discord.gg/GDvxHgXjkk) so you can be assigned a range of chunks
to work on.

## Linux (Ubuntu 22.04)

    sudo snap install --classic go
    go install github.com/brentp/gargs@latest
    mkdir -p $HOME/.local/bin
    ln -nsf $HOME/go/bin/gargs $HOME/.local/bin
    echo 'export PATH="$PATH:$HOME/.local/bin"' >> $HOME/.bashrc
    export PATH="$PATH:$HOME/.local/bin"

    ./run-search.sh

# Uncompressing binary universe files

    ./unpack.lua < output/universe-xxxx.txt > output/universe-xxx.txt

# Design rationale

**TODO**: clean up, this is a chat dump from SE Discord.

The general idea is that there are 7 major families of science packs that
require space resources: **P**roduction, **U**tility, **B**iological,
**E**nergy, **A**stronomical, **M**aterial, **D**eep Space; their primary
resources are vulcanite, cryonite, vitamelange, holmium, beryllium, iridium,
naquium, respectively. I'll use the resources and the science packs
interchangeably during this discussion.

In a way, D is easier to provision: it's only found in asteroid fields, and it
takes pretty much everything else as an input for processing, so as discussed
elsewhere in the channel the idea is to find a nearby naquium field. At request
of other people in the channel, I've also added the constraint that it should
have methane ice, and a little bit of water/iron ore so we can make sulfuric
acid locally with a biosludge loop.

P is all about vulcanite, and although we get a guaranteed vulcanite planet,
it's _also_ guaranteed to be waterless; the intended solution is to ship in
water ice etc. but we just cheese it and search for seeds that have a fully
volcanic biome (so vulcanite patches actually spawn) but also some water.

Similarly, U and B require frozen/grassy biomes; we also absolutely need the
latter to be a _primary_ (since later bio science packs take bio core
fragments).

M requires enriched vulcanite (not otherwise consumed by other recipes) and
plenty of vulcanite overall; I make it in the same surface as P for
convenience.

Similarly for E, it takes a lot of cryonite, so I make it in the same surface
as U.

A is the wildcard here; it takes even-ish amounts of vulcanite and cryonite, so
I don't really care where it spawns, as long as I can get a lot of it.

Now, there are some refinements I make to these search criteria:

* it's not as common for non-volcanic planets, but it's possible for cryo/beryl
  planets to be waterless for instance (I think vita too?); that's non-viable
  for local processing, so I skip these planets altogether;
* several resources need secondary inputs for basic processing (e.g. uniquely
  for vita it needs sand _input_ for processing); since a T4 science pack takes
  1538 vita ore and 248 stone, I penalize planets if they have a ratio of these
  two resources that's worse 6:1, as I won't be able to effectively use the
  extra vita;
* same for holmium and copper, and holmium/iridium and coal (for plastic, for
  making ion exchange beads etc.);
* it turns out a lot of these recipes take oil, directly or otherwise (usually
  sulfur, or sulfuric acid, or …); I also require oil to not totally suck.

Other considerations:

* I overvalue patch frequency over richness/size for logistic ease; they're
  _mostly_ linked together but all else being equal more frequent patches means
  it's easier to get the outpost running initially.
* I believe large planets tend to have more scattered patches for similar % of
  resources available? I want things to be compact for logistic simplicity, but
  not _too_ compact — you just don't get many patches out of a 500 radius moon.
  I therefore devalue planets for being smaller than 2000 tiles (because
  frequency decreases with planet radius, that naturally punishes planets for
  being too big);
* I actually require e.g. vita:stone ratios to be better than 6:1; about the
  square root of that (2.5:1 or so) so it's easier to actually find patches of
  the secondary resource; variance measn that for exact ratios you'll often
  found that the secondary resource is barely available on the planet surface.
* I normalize each of the BEAM scores by how much that ore is actually consumed
  in science packs; B consumes double the vita ore than M consumes iridium ore,
  so I want B planets to be that much richer (same with naq processing, it
  takes 2× as much vita as it does any other ore).

Finally, I average the BEAMD scores with a potential average with exponent -4,
which means the final score is a soft-min of the individual resource scores.

Caveats:

* I compute the overall required resources for each item based on the total T4
  cost, but some of that cost will be borne exclusively in space; using the
  _ingot_ cost for each material is not accurate (for material we'll want to
  make girders, bearings etc. on ground anyway, and vita has a much more
  complicated processing chain), so the material costs should probably be
  tweaked based on final blueprints/strategies;
* This scoring function completely ignores the reality of actual on-ground
  availability; it's possible to generate the actual resource count with a mod
  etc. but I never got around to it; it's probably sensible to fully scan
  candidate seeds and get concrete numbers for those.
* An assumption that I think people were unaware or just silently agreed with
  was bundling holmium/iridite with cryo/vulc; does that make sense or do we
  want separate primaries for those resources and ship cubes/rods in?
* Right now, beryl planets are mostly unconstrained in the seed search; should
  we demand more of them (e.g. also have good iron for steel etc.)?
* I don't punish _planets_ for being too far out; part of my assumption is that
  since I'm already requiring them to have good oil, the extra rocket/cannon
  cost is just not a big deal to begin with.
* The scoring function completely fails to take into account how may science
  packs of each kinds we need to beat the game, and in particular probably
  overvalues D as a result. Does anybody have numbers on the PUBEAMD packs
  consumed and/or a tentative research queue so that can be estimated and
  reweighted accordingly?

# Packed format rationale

    -rw-rw-r-- 1 fabio fabio   415526  7月 29 21:30 seeds.bin
    -rw-rw-r-- 1 fabio fabio   410171  7月 29 21:30 seeds.bin.gz
    -rw-rw-r-- 1 fabio fabio 13659435  7月 29 21:39 seeds.jsonl
    -rw-rw-r-- 1 fabio fabio  3073226  7月 29 21:39 seeds.jsonl.gz

~400 bytes per seed vs. 3000 bytes gzipped JSONL
