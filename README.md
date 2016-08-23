# Ripley

## reddit programming languages index

Ripley ranks reddit’s programming language subreddits by number of subscribers -- to see which [languages programmers are talking about this month][site].

This repo holds the script used to scrape reddit.

## To do:

- more unit tests
- account for ties (currently done manually)

## History

- August 23, 2016 - 0.4.0
  - added a linter (Credo), started writing docs & tests, some refactoring
  - merged Elixir to master
- August 21, 2016 - 0.3.0
  - rewritten in Elixir, with every page a separate supervised process
- June 11, 2016 - 0.2.0
  - replaced the Go HTML template used to display the data with JavaScript
  - replaced writing data to stdout with writing to a file
  - added the date the data was scraped to the JSON
  - used for data for July-August 2016
- March 31, 2016 - 0.1.0
  - initial commit
  - used for data from April-June 2016

[site]: http://mikekreuzer.github.io/Ripley/
