const fs = require("fs");
const readline = require("readline");

const desiredResources = [
  "se-cryonite",
  "se-vulcanite",
  "se-iridium-ore",
  "se-holmium-ore",
  "se-beryllium-ore",
  "se-vitamelange",
];
const resourceMap = {
  "se-vitamelange": "B",
  "se-holmium-ore": "E",
  "se-beryllium-ore": "A",
  "se-iridium-ore": "M",
};

function checkBody(body, primary, secondary) {
  if (
    body.tags.water != "water_none" &&
    body.radius > 1000 &&
    primary in body.resource &&
    secondary in body.resource &&
    ((body.resource[primary] >= 1 && body.resource[secondary] >= 0.1) ||
      (body.resource[secondary] >= 1 && body.resource[primary] >= 0.1))
  ) {
    return body;
  }
  return null;
}

function findPrimaryOrSecondary(universe, primary, secondary = null) {
  for (let i = 0; i < universe.planets.length; i++) {
    const planet = checkBody(universe.planets[i], primary, secondary);
    if (planet) {
      return planet;
    }
  }
  for (let i = 0; i < universe.moons.length; i++) {
    const moon = checkBody(universe.moons[i], primary, secondary);
    if (moon) {
      return moon;
    }
  }
  return null;
}

function findNaquium(universe) {}

function findMaterial(universe) {
  return findPrimaryOrSecondary(universe, "se-vulcanite", "se-iridium-ore");
}

function findEnergy(universe) {
  return findPrimaryOrSecondary(universe, "se-cryonite", "se-holmium-ore");
}

function findAstro(universe) {
  return findPrimaryOrSecondary(universe, "se-beryllium-ore", "se-cryonite");
}

function findBio(universe) {
  return findPrimaryOrSecondary(universe, "se-vitamelange", "stone");
}

function score(universe) {
  const prodCount = universe.loot.reduce((counter, currentValue) => {
    return currentValue === "P" ? counter + 1 : counter;
  }, 0);
  if (prodCount >= 4) {
    console.log("Seed: ", universe.seed);
    console.log("Checking naq");
    const naqField = universe.fields.find((x) => {
      return x.delta_v <= 25000 && x.resource["se-naquium-ore"] == 1;
    });
    if (!naqField) return;
    console.log(naqField);
    console.log("Checking material");
    const material = findMaterial(universe);
    if (!material) return;
    console.log(material);
    console.log("Checking energy");
    const energy = findEnergy(universe);
    if (!energy) return;
    console.log(energy);
    console.log("Checking astro");
    const astro = findAstro(universe);
    if (!astro) return;
    console.log(astro);
    console.log("Checking bio");
    const bio = findBio(universe);
    if (!bio) return;
    console.log(bio);
    fs.appendFile("godSeeds.jsonl", JSON.stringify(universe));
  }
}

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout,
  terminal: false,
});

rl.on("line", (line) => {
  if (line.includes("scanning")) {
    console.log(line);
  } else {
    score(JSON.parse(line));
  }
});

rl.once("close", () => {
  // end of input
});
