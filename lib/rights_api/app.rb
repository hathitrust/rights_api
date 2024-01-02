# frozen_string_literal: true

require "sinatra"
require "sinatra/json"
require "sinatra/reloader" if development?

require_relative "schema"
require_relative "query"
require_relative "result"

module RightsAPI
  class App < Sinatra::Base
    # Redirect to the current version
    get "/" do
      redirect(request.url + "v1/")
    end

    get "/v1/?" do
      json Result.new.to_h
    end

    # The full-featured search
    Schema.names.each do |name|
      get "/v1/#{name}/?" do
        params = CGI.parse(request.query_string)
        do_query(params: params, table_name: name)
      end
    end

    # The "by id" queries
    Schema.names.each do |name|
      get "/v1/#{name}/:id" do |id|
        schema_class = Schema.class_for name: name
        params = {schema_class.primary_key.to_s => [id]}
        do_query(params: params, table_name: name)
      end
    end

    # This masks possible errors too effectively
    # error 400..404 do
    #  json Result.new.to_h
    # end

    private

    def do_query(table_name:, params: {})
      query = Query.new(params: params, table_name: table_name)
      json query.run.to_h
    rescue QueryParserError, Sequel::Error => e
      status 400
      json ErrorResult.new(exception: e).to_h
    end
  end
end
