# Ripley

## reddit programming languages index

Ripley ranks reddit’s programming language subreddits by number of subscribers -- to see which [languages programmers are talking about this month][site].

This repo holds the script used to scrape reddit.

## To do:

- unit tests
- account for ties (currently done manually)
- better handling of rate limiting & other scraping errors

## History

- June 11, 2016 - 0.2.0
  - Replaced the Go HTML template used to display the data with JavaScript
  - Replaced writing data to stdout with writing to a file
  - Added the date the data was scraped to the JSON
- March 31, 2016 - 0.1.0
  - Initial commit, April till June

[site]: http://mikekreuzer.github.io/Ripley/
