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
        schema = Schema.named(name: name)
        do_query(schema: schema)
      end
    end

    # The "by id" queries
    Schema.names.each do |name|
      get "/v1/#{name}/:id" do |id|
        schema = Schema.named(name: name)
        do_query(schema: schema, id: id)
      end
    end

    error 400..404 do
      json Result.new.to_h
    end

    private

    def do_query(schema:, id: nil)
      query = Query.new(schema: schema)
      json query.run(id: id).to_h
    end
  end
end
