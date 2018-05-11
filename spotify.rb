class Spotify
  VALID_TOGGLES = %w(shuffle repeat).freeze
  VALID_SHARES = %w(url uri).freeze
  NAME_REGEX = /[a-z0-9\s]*/
  URI_REGEX = /\Aspotify:(track|album|artist|user):([a-z0-9]+(:playlist:))*(spotify:playlist:)?[a-z0-9]{22}\z/i

  class << self
    def play(play_args)
      return unless valid_play?(play_args)
      send_command("play #{play_args}")
    end

    def stop
      send_command("stop")
    end

    def next
      send_command("next")
    end

    def prev
      send_command("prev")
    end

    def replay
      send_command("replay")
    end

    def pos(time)
      return unless time == time.to_i
      send_command("pos #{time.to_i}")
    end

    def vol(change = nil)
      return unless valid_volume_change?(change)
      send_command("vol #{change}")
    end

    def status
      send_command("status")
    end

    def share(share_item)
      return unless valid_share?(share_item)
      send_command("share #{share_item}")
    end

    private

    def send_command(command)
      output = `./spotify.sh #{command}`
      output = HELP_TEXT unless $?.success?
      [output, $?.success?]
    end

    def valid_volume_change?(vol_arg)
      if vol_arg == vol_arg.to_i
        vol_arg.between?(0, 100)
      else
        ["up", "down"].include?(vol_arg)
      end
    end

    def valid_toggle?(toggle_item)
      VALID_TOGGLES.include?(toggle_item)
    end

    def valid_share?(share_item)
      VALID_SHARES.include?(share_item) || share_item.empty?
    end

    def valid_play?(play_args)
      play_args.empty? || validate_uri(play_args) || validate_name(play_args)
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

    def name_provided?(play_args)
      !uri_provided(play_args)
    end

    def uri_provided?(play_args)
      play_command(play_args) == "uri"
    end

  rescue NoMethodError
    "Spotify cannot respond to the command requested"
  end
end
