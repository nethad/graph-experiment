# README

This is just an experiment about using Rails + Neo4j + d3.js

Clone the repo

bundle install

bin/rake db:migrate

bin/rake neo4j:migrate

bin/rails s

## neo4j.rb rake tasks

neo4j.rb comes with its own collection of rake tasks.
Good think is that they are "self-documented".
For example if you create a new neo4j model and then you try to use it, you
may see an error like:

---
    Neo4j::DeprecatedSchemaDefinitionError:           Some schema elements were defined by the model (which is no longer supported), but they do not exist in the database.  Run the following to create them:

    rake neo4j:generate_schema_migration[constraint,Actor,uuid]


    And then run `rake neo4j:migrate`
---

and that is exactly what you have to do.

`rake neo4j:generate`

will create neo4j migration files in:

`db/neo4j`

Running

`rake neo4j:migrate`

the migration will be exectuted directly on the neo4j database


## Example queries

MATCH (a:Actor)-[:ACTS_IN]-(m:Movie)
WHERE a.name = "Tom Hanks"
RETURN a, m
LIMIT 25

MATCH
(a:Actor)-[:ACTS_IN]-(m:Movie),
(a:Actor)-[:DIRECTED]-(m:Movie)
WHERE a.name = "Tom Hanks"
RETURN a, m
LIMIT 25

MATCH
(a:Actor)-[:ACTS_IN]-(m:Movie),
(a:Actor)-[:DIRECTED]-(m:Movie)
WHERE a.name = "Woody Allen"
RETURN a, m
LIMIT 25

MATCH
(a:Director)-[:DIRECTED]-(m:Movie),
(b:Actor)-[:ACTS_IN]-(m:Movie)
WHERE a.name = "Woody Allen" AND b.name = "Mia Farrow"
RETURN a, b, m
LIMIT 25
