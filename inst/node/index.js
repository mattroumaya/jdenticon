// libs
const jdenticon = require("jdenticon");
const fs = require("fs");


// args
const params = {
  filePath: process.argv[2],
  fileName: process.argv[3],
  size:     Number(process.argv[4]),
  value:    process.argv[5],
  config:   JSON.parse(process.argv[6]),
  type:     process.argv[7]
}

params.fullPath = `${params.filePath}/${params.fileName}.${params.type}`;
var img = null;

// create jdenticon
if(params.type === 'svg'){
  img = jdenticon.toSvg(params.value, params.size, params.config);
}else{
  img = jdenticon.toPng(params.value, params.size, params.config);
}


// save
fs.writeFileSync(params.fullPath, img);

// log
console.log(JSON.stringify(params, null, "  "));
