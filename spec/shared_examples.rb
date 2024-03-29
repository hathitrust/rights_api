# frozen_string_literal: true

RSpec.shared_examples "400 response" do
  it "returns an HTTP 400 response" do
    expect(last_response.status).to eq 400
  end
end

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
    expect(response).to be_a(Hash)
    expect(response[:total]).not_to be_nil
    expect(response[:start]).not_to be_nil
    expect(response[:end]).not_to be_nil
    expect(response[:data]).to be_a(Array)
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

def validate_access_profiles_row(row)
  expect(row[:id]).to be_a(Integer)
  expect(row[:name]).to be_a(String)
  expect(row[:description]).to be_a(String)
end

def validate_access_statements_row(row)
  expect(row[:statement_key]).to be_a(String)
  expect(row[:statement_url]).to be_a(String)
  expect(row[:statement_head]).to be_a(String)
  expect(row[:statement_text]).to be_a(String)
  expect(row[:statement_url_aux]).to be_a(String).or(be_nil)
  expect(row[:statement_icon_icon_aux]).to be_a(String).or(be_nil)
  expect(row[:statement_icon_aux]).to be_a(String).or(be_nil)
end

def validate_access_statements_map_row(row)
  expect(row[:attribute]).to be_a(String)
  expect(row[:access_profile]).to be_a(String)
  expect(row[:statement_key]).to be_a(String)
end

# Validate a row from ht_rights.attributes
# and eventually the structure by ht_rights.rights_current.attribute (see DEV-1008)
def validate_attributes_row(row)
  expect(row[:id]).to be_a(Integer)
  expect(row[:name]).to be_a(String)
  expect(row[:type]).to be_a(String)
  expect(row[:description]).to be_a(String)
end

# Validate a row from ht_rights.reasons
# and eventually the structure by ht_rights.rights_current.reason (see DEV-1008)
def validate_reasons_row(row)
  expect(row[:id]).to be_a(Integer)
  expect(row[:name]).to be_a(String)
  expect(row[:description]).to be_a(String)
end

# Validate a row from ht_rights.rights_current or ht_rights.rights_log
def validate_rights_row(row)
  expect(row[:namespace]).to be_a(String)
  expect(row[:id]).to be_a(String)
  expect(row[:htid]).to be_a(String)
  validate_attributes_row row[:attribute]
  validate_reasons_row row[:reason]
  validate_sources_row row[:source]
  validate_access_profiles_row row[:access_profile]
  expect(row[:time]).to be_a(String)
end

def validate_sources_row(row)
  expect(row[:id]).to be_a(Integer)
  expect(row[:name]).to be_a(String)
  expect(row[:description]).to be_a(String)
  expect(row[:digitization_source]).to be_a(String).or(be_nil)
  validate_access_profiles_row row[:access_profile]
end
