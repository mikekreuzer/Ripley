'use strict';

var xmlhttp = new XMLHttpRequest(),
  url = 'data/data.json'; // hard wired for now, see below
xmlhttp.onreadystatechange = function () {
  if (xmlhttp.readyState === 4 && xmlhttp.status === 200) {
    processCurrentData(xmlhttp.responseText);
  }
};
xmlhttp.open('GET', url, true);
xmlhttp.send();

function processCurrentData(response) {
  var json = JSON.parse(response),
    // get date & find the file from a year before, both hard wired until April 2017
    xmlhttp2 = new XMLHttpRequest(),
    url2 = 'data/04-2016.json'; // hard wired for now
  xmlhttp2.onreadystatechange = function () {
    if (xmlhttp2.readyState === 4 && xmlhttp2.status === 200) {
      processOldData(xmlhttp2.responseText, json);
    }
  };
  xmlhttp2.open('GET', url, true);
  xmlhttp2.send();
}

function processOldData(response, json) {
  var data = json.data,
    startJson = JSON.parse(response),
    startData = startJson.data,
    i,
    out = '<h2><a id="data" class="anchor" href="#data" aria-hidden="true">' +
    '<span aria-hidden="true" class="octicon octicon-link"></span></a>' + json.title + '</h2>' +
    '<table><tr><th>Rank</th><th>Language</th><th>Subscribers</th><th>% Share</th><th>Change vs<br/>April 2016</th></tr>';
  for (i = 0; i < 20; i = i + 1) {
    out += '<tr><td>' + (i + 1) + '</td>' +
    '<td><a href="' + data[i].url + '">' + data[i].name + '</a></td>' +
    '<td>' + data[i].subsstring + '</td>' +
    '<td>' + data[i].percentage + '</td>' +
    '<td>' + checkHistory(data[i].name, i, startData) + '</td></tr>';
  }
  out += '</table><p>Outside of the top 20: ';

  for (i = 20; i < data.length; i = i + 1) {
    out += '<a href="' + data[i].url + '">' + data[i].name + '</a> (' + data[i].subsstring + '), ';
  }
  out = out.replace(/,\s$/, '') + '.</p>';

  out += '<p>Pages scraped: ' + json.dateScraped + '</p>';
  document.getElementById('outputDiv').innerHTML += out;
}

function checkHistory(name, index, historicalData) {
  var oldIndex;
  for (var i = 0; i < historicalData.length; i = i + 1) {
    if(name === historicalData[i].name) {
      oldIndex = i;
      break;
    }
  }
  if(index < oldIndex) {
    return '<img src="images/up.png" alt="up" width="48" height="32" style="margin-top:-9px;margin-bottom:-15px;padding:0"> from ' + (oldIndex + 1);
  } else if(index > oldIndex) {
    return '<img src="images/down.png" alt="down" width="48" height="32" style="margin-top:-9px;margin-bottom:-15px;padding:0"> from ' + (oldIndex + 1);
  } else {
    return oldIndex; // '&nbsp;';
  }
}
