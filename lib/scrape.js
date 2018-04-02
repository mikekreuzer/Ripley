const cheerio = require('cheerio'),
  comparer = require('./comparer'),
  fetch = require('node-fetch'),
  fs = require('fs'),
  languages = require('./languages'),
  moment = require('moment'),
  path = require('path');

let requestAsync = function(lang) {
  return new Promise((resolve, reject) => {
    fetch(lang.url, {
      headers: {
        'User-Agent': 'Mac:com.mikekreuzer.ripley:0.8.4 (by /u/mikekreuzer)'
      }
    }).then(res => res.text())
      .then(body => {
        let $ = cheerio.load(body);
        lang.subsstring = $('.subscribers .number').text();
        lang.subscribers = parseInt(lang.subsstring.replace(/,/g, ''), 10);
        resolve(lang);
      }).catch(err => reject(err));
  });
};

let addIndexAndPercentages = function(arrayOfLanguages) {
  if (!Array.isArray(arrayOfLanguages)) {
    return;
  }
  let total = arrayOfLanguages.reduce((prevVal, elem) => {
    return prevVal + elem.subscribers;
  }, 0);
  return arrayOfLanguages.map((lang, index) => {
    lang.index = index + 1;
    lang.percentage = (parseFloat(lang.subscribers) / total * 100).toFixed(1);
    return lang;
  });
};

let saveJSONFile = function(data) {
  const dateTime = moment(),
    dateTimeString = dateTime.format(),
    fileName = path.join('out', dateTime.format('MM-YYYY') + '.json'),
    titleString = dateTime.format('MMMM YYYY');
  let dataToSave = {
    'title': titleString,
    'dateScraped': dateTimeString,
    'data': data
  };
  fs.writeFile(fileName, JSON.stringify(dataToSave, null, 2), (err) => {
    if (err) throw err;
  });

  comparer.getComparison(dataToSave);
};

exports.getParallel = async function() {
  try {
    let data = await Promise.all(languages.map(requestAsync));
    data.sort((a, b) => {
      return b.subscribers - a.subscribers;
    });
    data = addIndexAndPercentages(data);
    saveJSONFile(data);
  } catch (err) {
    console.error(err);
  }
};
