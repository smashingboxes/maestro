ENV["RACK_ENV"] = "test"

require "rspec"
require "pry-byebug"
require_relative "../app"
require_relative "../spotify"

describe "Spotify" do
  let(:command_stub) { `echo 'hello'` } # Prevent RSpec from executing real commands

  describe ".stop" do
    subject { Spotify.stop }

    it "stops Spotify" do
      expect(Spotify).to receive(:`).with("./spotify.sh stop").and_return(command_stub)
      subject
    end
  end

  describe ".next" do
    subject { Spotify.next }

    it "advances to the next song" do
      expect(Spotify).to receive(:`).with("./spotify.sh next").and_return(command_stub)
      subject
    end
  end

  describe ".prev" do
    subject { Spotify.prev }

    it "replays the previous song" do
      expect(Spotify).to receive(:`).with("./spotify.sh prev").and_return(command_stub)
      subject
    end
  end

  describe ".replay" do
    subject { Spotify.replay }

    it "replays the current song" do
      expect(Spotify).to receive(:`).with("./spotify.sh replay").and_return(command_stub)
      subject
    end
  end

  describe ".pos" do
    subject { Spotify.pos(pos_args) }

    context "with an integer" do
    end
  end

  describe ".vol" do
    subject { Spotify.vol(vol_args) }

    context "up" do
      let(:vol_args) { "up" }

      it "increases the volume" do
        expect(Spotify).to receive(:`).with("./spotify.sh vol up").and_return(command_stub)
        subject
      end
    end

    context "down" do
      let(:vol_args) { "down" }

      it "decreases the volume" do
        expect(Spotify).to receive(:`).with("./spotify.sh vol down").and_return(command_stub)
        subject
      end
    end

    context "with a volume integer" do
    end
  end

  describe ".status" do
    subject { Spotify.status }

  end

  describe ".share" do
    subject { Spotify.share(share_args) }

  end

  describe ".play" do
    subject { Spotify.play(play_args) }

  end
end
