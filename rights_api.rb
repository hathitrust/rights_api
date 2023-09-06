# frozen_string_literal: true

$LOAD_PATH << "./lib"
# require "canister"
require "rights_api/rights_api"
require "sinatra"
require "sinatra/json"
require "sinatra/reloader" if development?

USAGE = <<~END_USAGE
  API_URL => this usage summary
  API_URL/access_profiles => contents of the access_profiles table
  API_URL/attributes => contents of the attributes table
  API_URL/reasons => contents of the reasons table
  API_URL/rights?htid=HTID => query rights_current for current rights on HTID
END_USAGE

get "/" do
  json({usage: USAGE})
end

get "/access_profiles" do
  json RightsAPI.access_profiles
end

get "/attributes" do
  json RightsAPI.attributes
end

get "/reasons" do
  json RightsAPI.reasons
end

get "/rights" do
  htid = params[:htid]
  return 400 if htid.nil?

  json(RightsAPI.rights(htid))
end

get "/sources" do
  json RightsAPI.sources
end

get "/version" do
  json({version: RightsAPI::VERSION})
end
