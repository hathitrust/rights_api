# frozen_string_literal: true

require "sinatra"
require "sinatra/json"
require "sinatra/reloader" if development?

require_relative "query"

module RightsAPI
  class App < Sinatra::Base
    USAGE = <<~END_USAGE
      API_URL => this usage summary
      API_URL/access_profiles => contents of the access_profiles table
      API_URL/access_profiles/1 => access_profile entry with id=1
      API_URL/access_statements => contents of the access_stmts table
      API_URL/access_statements/pd => access_stmts entry with stmt_key=pd
      API_URL/attributes => contents of the attributes table
      API_URL/attributes/1 => attributes entry with id=1
      API_URL/reasons => contents of the reasons table
      API_URL/reasons/1 => reasons entry with id=1
      API_URL/rights/HTID => query rights_current for current rights on HTID
      API_URL/rights_log/HTID => query rights_current for rights history on HTID
    END_USAGE

    STANDARD_TABLES = %w[attributes access_profiles access_statements reasons sources]

    # Redirect to the current version
    get "/" do
      redirect(request.url + "v1/")
    end

    get "/v1/?" do
      json({usage: USAGE})
    end

    get "/v1/rights/:htid" do |htid|
      json RightsAPI.rights(htid)
    end

    get "/v1/rights_log/:htid" do |htid|
      json RightsAPI.rights_log(htid)
    end

    # The "all" queries for most tables
    STANDARD_TABLES.each do |name|
      get "/v1/#{name}/?" do
        json(RightsAPI.send(name.to_sym))
      end
    end

    # The "by id" queries for most tables
    STANDARD_TABLES.each do |name|
      get "/v1/#{name}/:id" do |id|
        data = (RightsAPI.send name.to_sym)[hash_key(name: name, key: id)]
        data = {} if data.nil?
        json data
      end
    end

    private

    # Most tables have integer primary keys, but access_stmts is indexed by string
    def hash_key(name:, key:)
      (name == "access_statements") ? key.to_s : key.to_i
    end
  end
end
