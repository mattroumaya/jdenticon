let esbuild = require('esbuild')

let options = {
    entryPoints: ['./index.js'],
    bundle: true,
    minify: true,
    platform: 'node',
    target: 'node18.0',
    outdir: 'built'
};

esbuild.buildSync(options);
