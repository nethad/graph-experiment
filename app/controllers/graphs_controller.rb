class GraphsController < ApplicationController

  QUERIES = {
    'tom_hanks_simple' => '
      MATCH (a:Actor)-[:ACTS_IN]-(m:Movie)
      WHERE a.name = "Tom Hanks"
      RETURN a, m
      LIMIT 25
    ',
    'tom_hanks_actor_director' => '
      MATCH
      (a:Actor)-[:ACTS_IN]-(m:Movie),
      (a:Actor)-[:DIRECTED]-(m:Movie)
      WHERE a.name = "Tom Hanks"
      RETURN a, m
      LIMIT 25
    ',
    'woody_allen_actor_director' => '
      MATCH
      (a:Actor)-[:ACTS_IN]-(m:Movie),
      (a:Actor)-[:DIRECTED]-(m:Movie)
      WHERE a.name = "Woody Allen"
      RETURN a, m
      LIMIT 25
    ',
    'mia_farrow' => '
      MATCH
      (a:Director)-[:DIRECTED]-(m:Movie),
      (b:Actor)-[:ACTS_IN]-(m:Movie)
      WHERE a.name = "Woody Allen" AND b.name = "Mia Farrow"
      RETURN a, b, m
      LIMIT 25
    ',
    'meg_ryan_shortest_path' => '
      MATCH p=shortestPath(
        (bacon:Person {name:"Kevin Bacon"})-[*]-(meg:Person {name:"Meg Ryan"})
      )
      RETURN p
    ',
    'kevin_bacon' => '
      MATCH (bacon:Person {name:"Kevin Bacon"})-[*1..3]-(hollywood)
      RETURN DISTINCT hollywood
    '
  }

  def index
    @queries = QUERIES
  end

end
