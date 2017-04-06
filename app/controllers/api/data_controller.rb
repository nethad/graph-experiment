class Api::DataController < ApplicationController

  NEO4J_DATABASE_ENDPOINT = 'http://localhost:7474'

  # QUERIES = {
  #   tom_hanks_simple: '
  #     MATCH (a:Actor)-[:ACTS_IN]-(m:Movie)
  #     WHERE a.name = "Tom Hanks"
  #     RETURN a, m
  #     LIMIT 25
  #   ',
  #   tom_hanks_actor_director: '
  #     MATCH
  #     (a:Actor)-[:ACTS_IN]-(m:Movie),
  #     (a:Actor)-[:DIRECTED]-(m:Movie)
  #     WHERE a.name = "Tom Hanks"
  #     RETURN a, m
  #     LIMIT 25
  #   ',
  #   woody_allen_actor_director: '
  #     MATCH
  #     (a:Actor)-[:ACTS_IN]-(m:Movie),
  #     (a:Actor)-[:DIRECTED]-(m:Movie)
  #     WHERE a.name = "Woody Allen"
  #     RETURN a, m
  #     LIMIT 25
  #   ',
  #   mia_farrow: '
  #     MATCH
  #     (a:Director)-[:DIRECTED]-(m:Movie),
  #     (b:Actor)-[:ACTS_IN]-(m:Movie)
  #     WHERE a.name = "Woody Allen" AND b.name = "Mia Farrow"
  #     RETURN a, b, m
  #     LIMIT 25
  #   ',
  #   meg_ryan_shortest_path: '
  #     MATCH p=shortestPath(
  #       (bacon:Person {name:"Kevin Bacon"})-[*]-(meg:Person {name:"Meg Ryan"})
  #     )
  #     RETURN p
  #   ',
  #   kevin_bacon: '
  #     MATCH (bacon:Person {name:"Kevin Bacon"})-[*1..3]-(hollywood)
  #     RETURN DISTINCT hollywood
  #   '
  # }

  # MATCH (a:Actor)-[:ACTS_IN]-(m:Movie)
  # WHERE a.name = "Tom Hanks"
  # RETURN a, m
  # LIMIT 25
  #
  # MATCH
  # (a:Actor)-[:ACTS_IN]-(m:Movie),
  # (a:Actor)-[:DIRECTED]-(m:Movie)
  # WHERE a.name = "Tom Hanks"
  # RETURN a, m
  # LIMIT 25
  #
  # MATCH
  # (a:Actor)-[:ACTS_IN]-(m:Movie),
  # (a:Actor)-[:DIRECTED]-(m:Movie)
  # WHERE a.name = "Woody Allen"
  # RETURN a, m
  # LIMIT 25
  #
  # MATCH
  # (a:Director)-[:DIRECTED]-(m:Movie),
  # (b:Actor)-[:ACTS_IN]-(m:Movie)
  # WHERE a.name = "Woody Allen" AND b.name = "Mia Farrow"
  # RETURN a, b, m
  # LIMIT 25
  #
  # MATCH p=shortestPath(
  #   (bacon:Person {name:"Kevin Bacon"})-[*]-(meg:Person {name:"Meg Ryan"})
  # )
  # RETURN p
  #
  # MATCH (bacon:Person {name:"Kevin Bacon"})-[*1..3]-(hollywood)
  # RETURN DISTINCT hollywood

  def show
    response = execute_query(QUERIES[:meg_ryan_shortest_path])
    render json: response.body
  end

  private

  # def query
  #   "MATCH p=shortestPath(
  #       (bacon:Person {name:\"Kevin Bacon\"})-[*]-(meg:Person {name:\"Meg Ryan\"})
  #     )
  #     RETURN p"
  # end

  def connection
    Faraday.new(url: NEO4J_DATABASE_ENDPOINT) do |faraday|
      faraday.response :logger                  # log requests to STDOUT
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end
  end

  def neo4j_query_payload(query)
    {
      "statements": [
        {
          "statement": query,
          "resultDataContents": ["row", "graph"]
        }
      ]
    }.to_json
  end

  def execute_query(query)
    connection.post do |req|
      req.url '/db/data/transaction/commit'
      req.headers['Content-Type'] = 'application/json'
      req.body = neo4j_query_payload(query)
    end
  end

end
