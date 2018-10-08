class Spotify
  APP_PATH = "/Applications/Spotify.app".freeze # TODO: Make this configurable
  VALID_TOGGLES = %w(shuffle repeat).freeze
  VALID_SHARES = %w(url uri).freeze
  NAME_REGEX = /\A[a-z0-9\.\-_\s]*\z/i
  URI_REGEX = %r{
  \A
    uri\s
    spotify:(track|album|artist|user):
    ([a-z0-9]+(:playlist:))*
    (spotify:playlist:)?
    [a-z0-9]{22}
  \z
  }ix

  class << self
    def play(play_args = "")
      return invalid_command unless valid_play?(play_args)
      send_command("play #{play_args}")
    end

    def pause
      send_command("pause")
    end

    def stop
      send_command("stop")
    end

    def next
      send_command("next")
    end

    alias_method :skip, :next

    def prev
      send_command("prev")
    end

    def replay
      send_command("replay")
    end

    def restart
      quit
      sleep(5) # Give Spotify a few seconds to shut down
      `open #{APP_PATH}`
      output = $?.success? ? "Spotify has been restarted" : "I had some trouble restarting Spotify"
      [output, $?.success?]
    end

    def pos(time)
      return invalid_command unless time == time.to_i
      send_command("pos #{time.to_i}")
    end

    def quit
      send_command("quit")
    end

    def status
      send_command("status")
    end

    def share(share_item)
      return invalid_command unless valid_share?(share_item)
      send_command("share #{share_item}")
    end

    def toggle(toggle_item)
      return invalid_command unless valid_toggle?(toggle_item)
      send_command("toggle #{toggle_item}")
    end

    def vol(change = "")
      return invalid_command unless valid_volume_change?(change)
      send_command("vol #{change}")
    end

    private

    def send_command(command)
      output = `./spotify.sh #{command.rstrip}`
      output = HELP_TEXT unless $?.success?
      [output, $?.success?]
    end

    def invalid_command
      [HELP_TEXT, false]
    end

    def valid_volume_change?(vol_arg)
      if vol_arg == vol_arg.to_i.to_s
        vol_arg.to_i.between?(0, 100)
      else
        ["", "up", "down"].include?(vol_arg)
      end
    end

    def valid_toggle?(toggle_item)
      VALID_TOGGLES.include?(toggle_item)
    end

    def valid_share?(share_item)
      VALID_SHARES.include?(share_item) || share_item.empty?
    end

    def valid_play?(play_args)
      return true if play_args.empty?
      return validate_uri(play_args) if uri_provided?(play_args)
      validate_name(play_args)
    end

    def validate_uri(uri)
      URI_REGEX.match(uri)
    end

    def validate_name(name)
      NAME_REGEX.match(name)
    end

    def play_command(play_args)
      play_args.split(" ").first
    end

    def uri_provided?(play_args)
      play_command(play_args) == "uri"
    end
  end
end
