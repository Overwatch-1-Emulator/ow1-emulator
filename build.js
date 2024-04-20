const fs = require('node:fs');
const overpy = require("./overpy/VS Code Extension/overpy.js");

const version = process.env.NEXT_VERSION;

generateWorkshop("main.opy", "6v6-adj.txt")

function generateWorkshop(mainFileName="main.opy", outputFileName="out.txt", srcDirectory="./src/", buildDirectory="./build/") {
  try {
    const mainFilePath = srcDirectory + mainFileName;
    const outputFilePath = buildDirectory + outputFileName;

    let mainFileText = fs.readFileSync(mainFilePath, 'utf8');
    mainFileText = addVersionNumber(mainFileText, version)
    // mainFileText = addObfuscation(mainFileText)
    const compiledText = overpy.compile(mainFileText, "en-US", srcDirectory).result;

    fs.mkdirSync(buildDirectory, { recursive: true });
    fs.writeFileSync(outputFilePath, compiledText);
  } catch (err) {
    console.error(err);
  }
}

function addVersionNumber(mainFileText, version) {
  return `#!define GAMEMODE_VERSION "${version}"\n` + mainFileText
}

function addObfuscation(mainFileText) {
  return `#!obfuscate noRuleFilling noConstantObfuscation noCopyProtection\n` + mainFileText
}
