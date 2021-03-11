set("harbor.bind_addr", "0.0.0.0")

silence = blank()

autodj = playlist(
  "/some/path",
  reload_mode="watch"
)

live = input.harbor(
  "live",
  port=8001,
  password="livepassword",
  user="source"
)

radio = fallback(
  track_sensitive=false,
  [live, autodj, silence]
)

output.icecast(
  %mp3(
    bitrate=160
  ),
  host="localhost",
  port=8000,
  user="source",
  password="sourcepassword",
  mount="stream",
  name="Stream name",
  radio
)
