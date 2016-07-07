/* jshint strict:global, browser:true */
'use strict';
var xmlhttp = new XMLHttpRequest(),
  url = 'data/data.json';
xmlhttp.onreadystatechange = function () {
  if (xmlhttp.readyState === 4 && xmlhttp.status === 200) {
    myFunction(xmlhttp.responseText);
  }
};
xmlhttp.open('GET', url, true);
xmlhttp.send();
function myFunction(response) {
  var json = JSON.parse(response),
    data = json.data,
    i,
    out = '<h2><a id="data" class="anchor" href="#data" aria-hidden="true">' +
    '<span aria-hidden="true" class="octicon octicon-link"></span></a>' + json.title + '</h2>' +
    '<table><tr><th>Rank</th><th>Language</th><th>Subscribers</th><th>% Share</th></tr>';
  for (i = 0; i < 20; i = i + 1) {
    out += '<tr><td>' + (i + 1) + '</td>' +
    '<td><a href="' + data[i].url + '">' + data[i].name + '</a></td>' +
    '<td>' + data[i].subsstring + '</td>' +
    '<td>' + data[i].percentage + '</td></tr>';
  }
  out += '</table><p>Outside of the top 20: ';

  for (i = 20; i < data.length; i = i + 1) {
    out += '<a href="' + data[i].url + '">' + data[i].name + '</a> (' + data[i].subsstring + '), ';
  }
  out = out.replace(/,\s$/, '') + '.</p>';

  out += '<p>Pages scraped: ' + json.dateScraped + '</p>';
  document.getElementById('outputDiv').innerHTML += out;
}
