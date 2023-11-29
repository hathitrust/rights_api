# frozen_string_literal: true

require "cgi"
require "sinatra"
require "sinatra/json"
require "sinatra/reloader" if development?

require_relative "query"
require_relative "result"
require_relative "schema"

module RightsAPI
  class App < Sinatra::Base
    # Redirect to the current version
    get "/" do
      redirect(request.url + "v1/")
    end

    get "/v1/?" do
      json UsageResult.new.to_h
    end

    # The full-featured search
    Schema::NAME_TO_TABLE.keys.each do |name|
      get "/v1/#{name}/?" do
        params = CGI.parse(request.query_string)
        schema = Schema.named(name: name)
        do_query(params: params, schema: schema)
      end
    end

    # The "by id" queries
    Schema::NAME_TO_TABLE.keys.each do |name|
      get "/v1/#{name}/:id" do |id|
        schema = Schema.named(name: name)
        params = {schema.primary_key.to_s => [id]}
        do_query(params: params, schema: schema)
      end
    end

    private

    def do_query(params:, schema:)
      query = Query.new(params: params, schema: schema)
      json query.run.to_h
    rescue QueryParserError, Sequel::Error => e
      status 400
      json ErrorResult.new(exception: e).to_h
    end
  end
end
