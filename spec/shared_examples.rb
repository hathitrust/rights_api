# frozen_string_literal: true

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

RSpec.shared_examples "404 response" do
  it "returns an HTTP 404 response" do
    expect(last_response.status).to eq 404
  end
end
