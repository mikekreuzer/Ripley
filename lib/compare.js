const fs = require('fs'),
  moment = require('moment'),
  mustache = require('mustache'),
  path = require('path');

var getComparison = function(newData, outPath, fileSys=fs, mom=moment, comp=compare, templateReadCB=(err, oldData) => {
  if (err) throw err;
  comp(newData, JSON.parse(oldData), outPath);
}) {
  // todo: add checks for less than one year of data, there are two years' worth of data now
  // but if we ever need to rebuild old Markdown files...
  let fileOneYearAgo = mom().subtract(1, 'years').format('MM-YYYY') + '.json';
  fileSys.readFile(path.join(__dirname, '..', 'data', fileOneYearAgo), 'utf8', templateReadCB);
};

var template = function(data, outPath, fileSys=fs, mom=moment, stach=mustache, errorFn = (err) => {
  if (err) throw err;
}) {
  const fileName = path.join(outPath, mom().format('MM-YYYY') + '.md');
  fileSys.readFile(path.join(__dirname, '..', 'lib', 'template.mst'), 'utf8', (err, templateFile) => {
    if (err) throw err;
    let rendered = stach.render(templateFile, data);
    fileSys.writeFile(fileName, rendered, errorFn);
  });
};

var compare = function(newData, oldData, outPath, plate=template) {
  let comparedData = newData.data.map((language) => {
    let index = parseInt(language.index, 10),
      oldLanguage = (oldData.data.find(lang => {
        return language.name == lang.name;
      })),
      oldIndex = oldLanguage != undefined ? parseInt(oldLanguage.index, 10) : null,
      startString = 'https://mikekreuzer.github.io/Ripley/assets',
      endString = 'width="24" height="16" style="margin-top:2px;margin-bottom:-2px;"> from ';
    if (oldIndex == null) {
      language.delta = 'New';
    } else if (index < oldIndex) {
      language.delta = `<img src="${startString}/up.png" alt="Up" ${endString} ${oldIndex}`;
    } else if (index > oldIndex) {
      language.delta = `<img src="${startString}/down.png" alt="Down" ${endString} ${oldIndex}`;
    } else {
      language.delta = '&nbsp;';
    }
    return language;
  });

  let compared = {
    'title': newData.title,
    'dateScraped': newData.dateScraped,
    'oldTitle': oldData.title,
    'tableData': comparedData.slice(0, 20),
    'paraData': comparedData.slice(20),
  };

  if(compared.paraData.length > 0) {
    compared.paraData[compared.paraData.length - 1].last = true;
  }
  plate(compared, outPath);
};

module.exports.getComparison = getComparison;

if (process.env.NODE_ENV == 'test') {
  module.exports.test = {
    template: template,
    compare: compare
  };
}
