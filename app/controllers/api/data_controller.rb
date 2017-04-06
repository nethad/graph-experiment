class Api::DataController < ApplicationController

  def show
    # render json: json_data

    # neo4j_session = Neo4j::Session.open(:server_db, 'http://localhost:7474')
    # cypher = '
    #   MATCH p=shortestPath(
    #     (bacon:Person {name:"Kevin Bacon"})-[*]-(meg:Person {name:"Meg Ryan"})
    #   )
    #   RETURN p
    # '
    # render json: neo4j_session.query(cypher).to_json
    #
    #
    # neo4j_session = Neo4j::Session.open(:server_db, 'http://localhost:7474')
    # cypher = '
    #   MATCH p=shortestPath(
    #     (bacon:Person {name:"Kevin Bacon"})-[*]-(meg:Person {name:"Meg Ryan"})
    #   )
    #   RETURN p
    # '
    # neo4j_session.query(cypher)["data"].flatten
    #
    # 'http://localhost:7474/db/data/cypher'

    conn = Faraday.new(:url => 'http://localhost:7474') do |faraday|
      # faraday.request  :url_encoded             # form-encode POST params
      faraday.response :logger                  # log requests to STDOUT
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end

    # json_post = '
    #   {
    #     "query" : "MATCH (bacon:Person {name:\"Kevin Bacon\"})-[*1..3]-(hollywood) RETURN DISTINCT hollywood",
    #     "params" : {}
    #   }
    # '

    json_post =
      {
        "statements": [
          {
            "statement": "MATCH p=shortestPath(
                (bacon:Person {name:\"Kevin Bacon\"})-[*]-(meg:Person {name:\"Meg Ryan\"})
              )
              RETURN p",
            "resultDataContents": ["row", "graph"]
          }
        ]
      }.to_json

    resp = conn.post do |req|
      # req.url '/db/data/cypher'
      req.url '/db/data/transaction/commit'
      req.headers['Content-Type'] = 'application/json'
      req.body = json_post
    end

    render json: resp.body
  end

  # def show
  #   neo4j_session = Neo4j::Session.open(:server_db, 'http://localhost:7474')
  #   session.query(QUERY, json: json)
  # end

  private

  def json_data
    '
    {
      "results": [
          {
              "columns": ["user", "entity"],
              "data": [
                  {
                      "graph": {
                          "nodes": [
                              {
                                  "id": "1",
                                  "labels": ["User"],
                                  "properties": {
                                      "userId": "eisman"
                                  }
                              },
                              {
                                  "id": "8",
                                  "labels": ["Project"],
                                  "properties": {
                                      "name": "neo4jd3",
                                      "title": "neo4jd3.js",
                                      "description": "Neo4j graph visualization using D3.js.",
                                      "url": "https://eisman.github.io/neo4jd3"
                                  }
                              }
                          ],
                          "relationships": [
                              {
                                  "id": "7",
                                  "type": "DEVELOPES",
                                  "startNode": "1",
                                  "endNode": "8",
                                  "properties": {
                                      "from": 1470002400000
                                  }
                              }
                          ]
                      }
                  }
              ]
          }
      ],
      "errors": []
    }
    '
  end

  def json_data2
    '

    '
  end

end
