ENV["RACK_ENV"] = "test"

require "rspec"
require "rack/test"
require "json"
require "pry-byebug"
require_relative "../app"

describe "Maestro" do
  include Rack::Test::Methods

  subject { post "/maestro", params }
  let(:params) { { text: text } }
  let(:text) { "" }

  before { subject }

  def app
    Sinatra::Application
  end

  def json_response
    JSON.parse(last_response.body)
  end

  describe "/maestro help" do
    let(:text) { "help" }

    it "returns the usage text" do
      expect(last_response).to be_ok
      expect(json_response["response_type"]).to eq("in_channel")
      expect(json_response["text"]).to include("Usage:")
      expect(json_response["text"]).to include("/maestro")
      expect(json_response["text"]).to_not include("CLIENT_ID")
      expect(json_response["text"]).to_not include("CLIENT_SECRET")
    end
  end

  describe "Invalid command" do
    let(:text) { "bogus" }

    it "returns the usage text" do
      expect(last_response).to_not be_ok
      expect(json_response["response_type"]).to eq("in_channel")
      expect(json_response["text"]).to include("Usage:")
      expect(json_response["text"]).to include("/maestro")
      expect(json_response["text"]).to_not include("CLIENT_ID")
      expect(json_response["text"]).to_not include("CLIENT_SECRET")
    end
  end
end
