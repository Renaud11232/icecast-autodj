%include "config.liq"

set("harbor.bind_addr", harbor_bind_addr)

silence = blank()

autodj = playlist(playlist_path)

live = input.harbor(
  harbor_mountpoint,
  port=harbor_port,
  password=harbor_password,
  user=harbor_user
)

radio = fallback(
  track_sensitive=false,
  [live, playlist, silence]
)

output.icecast(
  %mp3(
    bitrate=mp3_bitrate
  ),
  host=icecast_host,
  port=icecast_port,
  user=icecast_user,
  password=icecast_password,
  mount=icecast_mountpoint,
  radio
)
