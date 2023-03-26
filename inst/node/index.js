// libs
const jdenticon = require("jdenticon");
const fs = require("fs");

// args
const filePath = process.argv[2];
const fileName = process.argv[3];
const size = Number(process.argv[4]);
const value = process.argv[5];

// create jdenticon
const png = jdenticon.toPng(value, size);

// log
console.log(`--- Creating jdenticon using value: ${value}`);
console.log(`--- Creating jdenticon using size: ${size}`);
console.log(`--- Saving jdenticon to path: ${filePath}`);

// save
fs.writeFileSync(`${filePath}/${fileName}.png`, png);





