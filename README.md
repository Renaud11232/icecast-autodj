# Icecast AutoDJ Server

This repository explains the process of creating and configuring a webradio server with the ability to continuously stream a playlist (AutoDJ) and also support live performence, if needed.

This is done thanks to three components, IceCast2 as the server. And EZStream and ffmpeg fot the AutoDJ.

## Installation

Installation and configuration instructions are written for Ubuntu Server.

```bash
sudo su
apt update
apt install icecast2 ezstream ffmpeg git
git clone https://github.com/Renaud11232/icecast-autodj.git
cp /etc/icecast2/icecast.xml /etc/icecast2/icecast.bcp.xml
cp configs/icecast.xml /etc/icecast2/icecast.xml
vi /etc/icecast2/incecast.xml #Edit to your needs
mkdir -p /etc/ezstream
cp configs/ezstream.xml /etc/ezstream/ezstream.xml
vi /etc/ezstream/ezstream.xml #Edit to your needs
vi /etc/ezstream/playlist.m3u #One file per line
cp systemd/ezstream.service /etc/systemd/system/
systemctl daemon-reload
systemctl enable icecast2
systemctl enable ezstream
systemctl start icecast2
systemctl start ezstream
```

## Configuration

The configuration files provided in this repository are given as a base you can use for your own server. You are free to modify and adapt them to your needs. You should at least change the passwords.

### IceCast2

The provided configuration file creates creates 3 mountpoints :
* `/stream` : The main mountpoint listener should connect to. This mountpoint will fall back to the `/live` mountpoint if there is no source connected. It is possible to stream to this mountpoint however `/live` is preferred if there is nobody already stremaing on it.
* `/live` : The mountpoint where live streams happen. This mountpoint will fall back to the `/autodj` mountpoint.
* `/autodj` : The mountpoint where AutoDJ will stream continuously.

### EZStream

The provided configuration makes EZStream stream as a source on a local IceCast server on the `/autodj` mountpoint. It will play continuously a playlist in a random order. It's alsso set up so it will reencode mp3 while streaming using `ffmpeg`. That way the stream bitrate will stay arround 160kb/s.

## Operating

There are 3 scripts you can use to interract with the server without restarting it.
* `refresh_playlist` will signal EZStream to reread it's playlist and start playing the new playlist after the current song.
* `reread_metadata` triggers rereading of metadata for the stream by running the program or script specified in `<metadata_progname/>`
* `skip_current_track` will signal EZStream to skip the current track.
