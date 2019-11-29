# README

## Coding Exercise - Http client written in Elixir

Build an HTTP client to retrieve data from https://dev-mw-test-service-staging-shakespeare.meltwater.io/sources/copyco


Provide the following extra functionality:

* Write a method to exclude / filter out all publishers without any source IDs associated. For example, the following entry should be removed:

  `{"url":"url3", "publisher":"Publisher3", "sourceIDs":[]}`

* Write a method that finds all publishers associated with a given source ID

* Verify your solution by introducing some tests
