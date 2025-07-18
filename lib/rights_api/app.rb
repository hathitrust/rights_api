# frozen_string_literal: true

require "cgi"
require "sinatra"
require "sinatra/json"
require "sinatra/reloader" if development?

require_relative "services"
# So Sequel knows where to look.
RightsAPI::Services[:database_connection]

require_relative "query"
require_relative "result"
require_relative "result/error_result"
require_relative "schema"

module RightsAPI
  class App < Sinatra::Base
    set :logging, true

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
        model = Schema.model_for(name: name)
        do_query(model: model, params: params)
      end
    end

    # The "by id" queries
    Schema.names.each do |name|
      get "/v1/#{name}/:id" do |id|
        model = Schema.model_for(name: name)
        params = {model.default_key.to_s => [id]}
        do_query(model: model, params: params)
      end
    end

    private

    def do_query(model:, params: {})
      query = Query.new(model: model, params: params)
      json query.run.to_h
    rescue QueryParserError, Sequel::Error => e
      status 400
      json ErrorResult.new(exception: e).to_h
    end
  end
end
