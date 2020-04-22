# Ripley

## reddit programming languages index

Ripley ranks reddit’s programming language subreddits by number of subscribers -- to see which [languages programmers are talking about this month][site].

This repo holds the script used to scrape reddit.

## To do:

- account for ties
- tests

## History

### Ruby (May 2018 - current)

- April 22, 2020 - 0.16.4
  - added languages: Concurnas, Gleam
- February 1, 2020 - 0.16.3
  - removed Monkey, the first language subreddit here to die
- January 11, 2020 - 0.16.2
  - added: Zig
- November 9, 2019 - 0.16.1
  - added: Red
- July 1, 2019 - 0.16.0
  - added back the commas for thousands, missing since v0.13.0 (not in time for July)
  - will need to touch up the intervening months' json files
- February 1, 2019 - 0.15.0
  - migrated site hosting off Github, to AWS S3
  - using the domain ripley.red
- October 21, 2018
  - added languages: Ballerina, Fantom, Nemerle, Oberon
- October 7, 2018 - 0.14.0
  - replaced Redd with my own code for the Reddit API (Redd was fine, but it's the core business of the script)
  - updated the rake dependency
- July 30, 2018 - 0.13.1
  - added languages: Chapel, Racket, Solidity, & Wasm
  - changed 'rank' to the pound sign to save some space
- May 27, 2018
  - added: Standard ML
- May 6, 2018 - 0.13.0
  - lucky 13
  - the reddit API now includes subscriber numbers, replaced Mechanize with Redd
  - languages array has subreddit name not url, in new style hash format
  - fixed some relative paths
  - rake file wound back, pending changes to Zine

### JavaScript (not used)

- April 9, 2018 - 0.12.0
  - CLI
- April 7, 2018 - 0.11.0
  - Jest, replacing Jasmine
  - some tests & refactoring
- April 2, 2018 - 0.10.2
  - ESLint
- April 1, 2018 - 0.10.1
  - rewritten in JavaScript

### Elixir (not used)

- February 19, 2018 - 0.9.1
  - rewritten Elixir version

### Ruby (July 2017 - April 2018)

- April 1, 2018
  - added: Opa
- March 17, 2018
  - added languages: AppleScript, ColdFusion, R, & VBA
  - updated the About page on the site
- February 9, 2018
  - added: Reason
- January 28, 2018
  - added: Monkey
- October 2, 2017
  - added: Ceylon
- October 1, 2017 - 0.8.2
  - started on the rake script to: run this, move the generated files to gitHub & the Zine repo, and to run Zine
- September 16, 2017
  - added: Purescript
- July 2, 2017 - 0.8.1
  - fixed missing URLs in the JSON
  - adopted gem-like structure
  - rolled March's Ruby data comparison script in
- July 1, 2017 - 0.8.0
  - starting again in Ruby
  - used for data for July 2017 (the Elixir code timed out, & this Ruby was a lot less effort than trying to debug the Elixir)

### Elixir (September 2016 - June 2017)

- July 1, 2017 - 0.7.2
  - to capture the changes below, and the Elixir code
- June 24, 2017
  - several dependency updates (still with the compiler warnings)
  - Elixir 1.4.5
- May 21, 2017
  - changed the heading '% share' to '%' to better display on the iPhone 6/7
- May 1, 2017
  - Elixir 1.4.2
  - added languages: Hack & Xojo
- March 6, 2017
  - Ruby script to convert the JSON files to Zine posts
- February 1, 2017 - 0.7.1
  - Elixir 1.4.0
  - version bumps for most dependencies (which mostly don't resolve a storm of new compiler deprecation & ambiguity warnings)
  - added brackets to a function call in HTTPMock (to fix my own new warnings)
  - used for data for March-June 2017
- December 4, 2016 - 0.7.0
  - added: Wolfram (in November)
  - Elixir 1.3.4
  - cleaned up tests & config, back to 96% coverage
  - used for data for January-February 2017
- September 22, 2016 - 0.6.3
  - Elixir 1.3.3
  - added a temp elixir_buildpack.config for Heroku
  - fixed Application/GenServer stop calls in tests
  - used for data for October-December 2016
- September 20, 2016 - 0.6.2
  - minor refactoring, simplified config files, consistent use of **MODULE** names
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

### Go (April - August 2016)

- June 11, 2016 - 0.2.0
  - replaced the Go HTML template used to display the data with JavaScript
  - replaced writing data to stdout with writing to a file
  - added the date the data was scraped to the JSON
  - added languages: Agda, Crystal, Haxe, Idris, Kotlin, & Pony
  - used for data for July-August 2016
- March 31, 2016 - 0.1.0
  - initial commit
  - used for data from April-June 2016

[site]: https://ripley.red/
[exsite]: http://mikekreuzer.github.io/Ripley/
