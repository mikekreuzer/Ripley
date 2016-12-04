# Ripley

## reddit programming languages index

Ripley ranks reddit’s programming language subreddits by number of subscribers -- to see which [languages programmers are talking about this month][site].

This repo holds the script used to scrape reddit.

## To do:

- more unit tests
- account for ties (currently done manually)
- clean up the results site: navigate month to month, the css

## History
- December 4, 2016 - 0.7.0
  - added Wolfram language (in November)
  - Elixir 1.3.4
  - cleaned up tests & config, back to 96% coverage
- September 22, 2016 - 0.6.3
  - Elixir 1.3.3
  - added a temp elixir_buildpack.config for Heroku
  - fixed Application/GenServer stop calls in tests
  - used for data for October-December 2016
- September 20, 2016 - 0.6.2
  - minor refactoring, simplified config files, consistent use of __MODULE__ names
- September 11, 2016 - 0.6.1
  - updated floki from 0.9.0 to 0.10.1
  - added excoveralls
  - 100% test coverage, now to get some depth to the tests
- September 1, 2016 - 0.6.0
  - reverted to the JSON names I'd used earlier, including index & percentage (absent minded me)
  - replaced my homegrown testing version with :sys.get_state/1
  - used for data for September 2016
- August 30, 2016 - 0.5.0
  - added languages: OCaml, Smalltalk, Vala
  - added some more tests
- August 23, 2016 - 0.4.0
  - added a linter (Credo), started writing docs & tests, some refactoring
  - merged Elixir to master
- August 21, 2016 - 0.3.0
  - rewritten in Elixir, with every page a separate supervised process
- June 11, 2016 - 0.2.0
  - replaced the Go HTML template used to display the data with JavaScript
  - replaced writing data to stdout with writing to a file
  - added the date the data was scraped to the JSON
  - added languages: Agda, Crystal, Haxe, Idris, Kotlin, & Pony
  - used for data for July-August 2016
- March 31, 2016 - 0.1.0
  - initial commit
  - used for data from April-June 2016

[site]: http://mikekreuzer.github.io/Ripley/
