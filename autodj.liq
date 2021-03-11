%include "config.liq"

silence = blank()

autodj = playlist(playlist_path)

radio = fallback(
  track_sensitive=false,
  [autodj, silence]
)

output.icecast(
  %mp3(
    bitrate=160
  ),
  host=icecast_host,
  port=icecast_port,
  user=icecast_user,
  password=icecast_password,
  mount=icecast_mountpoint,
  radio
)
