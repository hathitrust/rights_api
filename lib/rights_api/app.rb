# frozen_string_literal: true

require "sinatra"
require "sinatra/json"
require "sinatra/reloader" if development?

require_relative "services"
# So Sequal knows where to look.
RightsAPI::Services[:database_connection]

# require_relative "model"
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
      json Result.new.to_h
    end

    # The full-featured search
    Schema.names.each do |name|
      get "/v1/#{name}/?" do
        do_query(table_name: name)
      end
    end

    # The "by id" queries
    Schema.names.each do |name|
      get "/v1/#{name}/:id" do |id|
        do_query(table_name: name, id: id)
      end
    end

    # This masks possible errors too effectively
    # error 400..404 do
    #  json Result.new.to_h
    # end

    private

    def do_query(table_name:, id: nil)
      query = Query.new(table_name: table_name)
      json query.run(id: id).to_h
    end
  end
end
