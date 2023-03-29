// libs
const jdenticon = require("jdenticon");
const fs = require("fs");

// args
const filePath = process.argv[2];
const fileName = process.argv[3];
const size = Number(process.argv[4]);
const value = process.argv[5];
const config = process.argv[6];
const type = process.argv[7];
const config_json = JSON.parse(config);

var fname = '';

// create jdenticon
if(type === 'svg'){
  fname = jdenticon.toSvg(value, size, config_json);
}else{
  fname = jdenticon.toPng(value, size, config_json);
}

// log
console.log(`--- Creating jdenticon of type      : ${type}`);
console.log(`--- Creating jdenticon using value  : ${value}`);
console.log(`--- Creating jdenticon using size   : ${size}`);
console.log(`--- Creating jdenticon using options: ${config}`);
console.log(`--- Saving jdenticon to path        : ${filePath}`);

// save
fs.writeFileSync(`${filePath}/${fileName}.${type}`, fname);





