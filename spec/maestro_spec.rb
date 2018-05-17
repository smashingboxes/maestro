ENV["RACK_ENV"] = "test"

require "rspec"
require "rack/test"
require "json"
require "pry-byebug"
require_relative "../app"
require_relative "../spotify"

describe "Maestro" do
  include Rack::Test::Methods

  subject { post "/maestro", params }
  let(:params) { { text: text } }
  let(:text) { "" }

  def app
    Sinatra::Application
  end

  def json_response
    JSON.parse(last_response.body)
  end

  shared_examples_for "a valid maestro command" do
    let(:expected_args) { any_args }
    it "invokes the correct Spotify method with the correct arguments" do
      expect(Spotify).to receive(expected_command).with(expected_args)
      subject
    end
  end

  describe "/maestro help" do
    let(:text) { "help" }

    it "returns the usage text" do
      subject
      expect(last_response).to be_ok
      expect(json_response["response_type"]).to eq("in_channel")
      expect(json_response["text"]).to include("Usage:")
      expect(json_response["text"]).to include("/maestro")
      expect(json_response["text"]).to_not include("CLIENT_ID")
      expect(json_response["text"]).to_not include("CLIENT_SECRET")
    end
  end

  describe "Valid command" do
    context "command with no args" do
      let(:text) { "stop" }
      let(:expected_command) { :stop }

      it_behaves_like "a valid maestro command"
    end

    context "command with args" do
      let(:text) { "pos #{time}" }
      let(:expected_command) { :pos }

      context "with a valid number" do
        let(:time) { "34" }

        it_behaves_like "a valid maestro command" do
          let(:expected_args) { time }
        end
      end
    end
  end

  describe "Invalid command" do
    let(:text) { "bogus" }

    it "returns the usage text" do
      subject
      expect(last_response).to be_ok
      expect(json_response["response_type"]).to eq("in_channel")
      expect(json_response["text"]).to include("Usage:")
      expect(json_response["text"]).to include("/maestro")
      expect(json_response["text"]).to_not include("CLIENT_ID")
      expect(json_response["text"]).to_not include("CLIENT_SECRET")
    end
  end

  describe "Bash command execution" do
    let(:text) { "status; ls" }
    it "returns the usage text" do
      subject
      expect(last_response).to be_ok
      expect(json_response["text"]).to include("Usage:")
      expect(json_response["text"]).to_not include("Gemfile")
    end
  end
end
