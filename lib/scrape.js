const cheerio = require('cheerio'),
  compare = require('./compare'),
  fetch = require('node-fetch'),
  fs = require('fs'),
  languages = require('./languages'),
  moment = require('moment'),
  path = require('path');

let requestAsync = function(lang, fetchMethod) {
  return new Promise((resolve, reject) => {
    fetchMethod(lang.url, {
      headers: {
        'User-Agent': 'Mac:com.mikekreuzer.ripley:0.8.4 (by /u/mikekreuzer)'
      }
    }).then(res => res.text())
      .then(body => {
        let $ = cheerio.load(body);
        lang.subsstring = $('.subscribers .number').text();
        lang.subscribers = parseInt(lang.subsstring.replace(/,/g, ''), 10);
        if (isNaN(lang.subscribers)) {
          reject(lang.name + ' uncountable');
        } else {
          resolve(lang);
        }
      }).catch(err => reject(err));
  });
};

let addIndexAndPercentages = function(arrayOfLanguages) {
  if (!Array.isArray(arrayOfLanguages)) {
    throw ('addIndexAndPercentages expects an array');
  }
  let total = arrayOfLanguages.reduce((prevVal, elem) => {
    return prevVal + parseInt(elem.subscribers, 10);
  }, 0);
  return arrayOfLanguages.map((lang, index) => {
    lang.index = index + 1;
    lang.percentage = (parseFloat(lang.subscribers) / total * 100).toFixed(1);
    return lang;
  });
};

let saveJSONFile = function(data, fs, dateFunc, comparisonFunc, errorFn = (err) => {
  if (err) throw err;
}) {
  const dateTime = dateFunc(),
    fileName = path.join('out', dateTime.format('MM-YYYY') + '.json');
  let dataToSave = {
    'title': dateTime.format('MMMM YYYY'),
    'dateScraped': dateTime.format(),
    'data': data
  };
  fs.writeFile(fileName, JSON.stringify(dataToSave, null, 2), errorFn);
  comparisonFunc(dataToSave);
};

module.exports.getParallel = async function(langs = languages,
  saveJSON = saveJSONFile,
  fileSys = fs,
  request = requestAsync,
  addIndex = addIndexAndPercentages) {
  try {
    let data = await Promise.all(langs.map(lang => request(lang, fetch)));
    data.sort((a, b) => {
      return b.subscribers - a.subscribers;
    });
    data = addIndex(data);
    saveJSON(data, fileSys, moment, compare.getComparison);
  } catch (err) {
    console.error(err);
  }
};

if (process.env.NODE_ENV == 'test') {
  module.exports.test = {
    addIndexAndPercentages: addIndexAndPercentages,
    requestAsync: requestAsync,
    saveJSONFile: saveJSONFile
  };
}
