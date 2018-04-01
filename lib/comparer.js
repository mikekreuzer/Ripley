const fs = require('fs'),
  moment = require('moment'),
  mustache = require('mustache'),
  path = require('path');

var getComparison = function(newData) {
  // drop checks for less than one year of data, there are two years worth of data now
  let fileOneYearAgo = moment().subtract(1, 'years').format('MM-YYYY') + '.json';
  fs.readFile(path.join('data', fileOneYearAgo), 'utf8', (err, oldData) => {
    if (err) throw err;
    compare(newData, JSON.parse(oldData));
  });
}

var template = function(data) {
  const fileName = path.join('out', moment().format('MM-YYYY') + '.md');
  fs.readFile(path.join('lib', 'template.mst'), 'utf8', (err, templateFile) => {
    if (err) throw err;
    let rendered = mustache.render(templateFile, data);
    fs.writeFile(fileName, rendered, (err) => {
      if (err) throw err;
    });
  });
}

var compare = function(newData, oldData) {
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
  })
  let compared = {
    'title': newData.title,
    'dateScraped': newData.dateScraped,
    'oldTitle': oldData.title,
    'tableData': comparedData.slice(0, 20),
    'paraData': comparedData.slice(20),
  }
  compared.paraData[compared.paraData.length - 1].last = true;
  template(compared);
}

module.exports.getComparison = getComparison;
