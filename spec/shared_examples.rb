# frozen_string_literal: true

SUPPORT_TABLES = %w[
  attributes
  access_profiles
  access_statements
  access_statements_map
  reasons
  sources
]

RSpec.shared_examples "404 response" do
  it "returns an HTTP 404 response" do
    expect(last_response.status).to eq 404
  end
end

RSpec.shared_examples "valid response" do
  it "returns valid JSON with no error" do
    expect(last_response).to be_ok
    expect(last_response.content_type).to eq("application/json")
    response = parse_json(last_response.body)
    expect(response).to be_an_instance_of(Hash)
    expect(response[:total]).not_to be_nil
    expect(response[:start]).not_to be_nil
    expect(response[:end]).not_to be_nil
    expect(response[:data]).to be_an_instance_of(Array)
  end
end

RSpec.shared_examples "empty response" do
  it_behaves_like "valid response"
  it "returns empty JSON with no error" do
    response = parse_json(last_response.body)
    expect(response[:total]).to eq(0)
    expect(response[:end] - response[:start]).to eq(0)
    expect(response[:data].count).to eq(0)
  end
end

RSpec.shared_examples "nonempty response" do
  it_behaves_like "valid response"
  it "returns nonempty JSON with no error" do
    response = parse_json(last_response.body)
    expect(response[:total]).to be > 0
    expect(response[:end] - response[:start]).to be >= 0
    expect(response[:data].count).to be > 0
  end
end

RSpec.shared_examples "nonempty rights response" do
  it_behaves_like "nonempty response"
  it "has valid rights data" do
    response = parse_json(last_response.body)
    response[:data].each do |row|
      validate_rights_row row
    end
  end
end

SUPPORT_TABLES.each do |table|
  RSpec.shared_examples "nonempty #{table} response" do
    it_behaves_like "nonempty response"
    it "has valid #{table} data" do
      response = parse_json(last_response.body)
      response[:data].each do |row|
        validator = "validate_#{table}_row".to_sym
        send validator, row
      end
    end
  end
end

def validate_access_profiles_row(row)
  expect(row[:id]).to be_an_instance_of(Integer)
  expect(row[:name]).to be_an_instance_of(String)
  expect(row[:description]).to be_an_instance_of(String)
end

def validate_access_statements_row(row)
  expect(row[:statement_key]).to be_an_instance_of(String)
  expect(row[:statement_url]).to be_an_instance_of(String)
  expect(row[:statement_head]).to be_an_instance_of(String)
  expect(row[:statement_text]).to be_an_instance_of(String)
  expect(row[:statement_url_aux]).to be_an_instance_of(String).or(be_nil)
  expect(row[:statement_icon_icon_aux]).to be_an_instance_of(String).or(be_nil)
  expect(row[:statement_icon_aux]).to be_an_instance_of(String).or(be_nil)
end

def validate_access_statements_map_row(row)
  expect(row[:attribute]).to be_an_instance_of(String)
  expect(row[:access_profile]).to be_an_instance_of(String)
  expect(row[:statement_key]).to be_an_instance_of(String)
end

# Validate a row from ht_rights.attributes
# and eventually the structure by ht_rights.rights_current.attribute (see DEV-1008)
def validate_attributes_row(row)
  expect(row[:id]).to be_an_instance_of(Integer)
  expect(row[:name]).to be_an_instance_of(String)
  expect(row[:type]).to be_an_instance_of(String)
  expect(row[:description]).to be_an_instance_of(String)
end

# Validate a row from ht_rights.reasons
# and eventually the structure by ht_rights.rights_current.reason (see DEV-1008)
def validate_reasons_row(row)
  expect(row[:id]).to be_an_instance_of(Integer)
  expect(row[:name]).to be_an_instance_of(String)
  expect(row[:description]).to be_an_instance_of(String)
end

# Validate a row from ht_rights.rights_current or ht_rights.rights_log
def validate_rights_row(row)
  expect(row[:namespace]).to be_an_instance_of(String)
  expect(row[:id]).to be_an_instance_of(String)
  expect(row[:attribute]).to be_an_instance_of(Integer)
  expect(row[:reason]).to be_an_instance_of(Integer)
  expect(row[:source]).to be_an_instance_of(Integer)
  expect(row[:access_profile]).to be_an_instance_of(Integer)
  expect(row[:time]).to be_an_instance_of(String)
end

def validate_sources_row(row)
  expect(row[:id]).to be_an_instance_of(Integer)
  expect(row[:name]).to be_an_instance_of(String)
  expect(row[:description]).to be_an_instance_of(String)
  expect(row[:access_profile]).to be_an_instance_of(Integer).or(be_nil)
  expect(row[:digitization_source]).to be_an_instance_of(String).or(be_nil)
end
