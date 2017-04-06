class Api::DataController < ApplicationController

  NEO4J_DATABASE_ENDPOINT = 'http://localhost:7474'

  def show
    query_key = params[:query] || GraphsController::QUERIES.keys.first
    response = execute_query(GraphsController::QUERIES[query_key.to_sym])
    render json: response.body
  end

  private

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
