#!/usr/bin/env node

const flags = require('commander'),
  pack = require('../package.json'),
  ripley = require('..');

try {

  flags
    .version(pack.version)
    .description('The script used to create Ripley, the reddit programming index')
    .option('-o, --out <dir>', 'directory to create the blog post in (default is cwd)')
    .parse(process.argv);

  let outPath = flags.out ? flags.out : process.cwd();
  ripley.scrape(outPath);

} catch (err) {
  console.log(err);
}
