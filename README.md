# Icecast AutoDJ Server

This repository explains the process of creating and configuring a webradio server with the ability to continuously stream a playlist (AutoDJ) and also support live performence, if needed.

This is done thanks to two main components, IceCast2 as the main server. And liquidsoap for the AutoDJ and live streaming.

## Installation

Installation and configuration instructions are written for Ubuntu Server. While the official instructions from liquidsoap recommend to install using the OCaml packages, I found out that using the provided `.deb` package is easier and cleaner. The `.deb` packages can be found on [their github](https://github.com/savonet/liquidsoap/releases). Pick the one corresponding to your distro/architecture. This guide uses Ubuntu focal/amd64

```bash
sudo su

apt update
apt install git icecast2 wget

#Installing icecast
vi /etc/icecast2/icecast.xml #Edit to your needs, you should at least change all the default passwords.

#Installing liquidsoap
wget https://github.com/savonet/liquidsoap/releases/download/v1.4.4/liquidsoap-v1.4.4_1.4.4-ubuntu-focal-amd64-1_amd64.deb
apt install ./liquidsoap-v1.4.4_1.4.4-ubuntu-focal-amd64-1_amd64.deb

#Getting this repository
git clone https://github.com/Renaud11232/icecast-autodj.git
cd icecast-autodj

#Copies provided configuration
mkdir -p /etc/liquidsoap
cp configs/radio.liq /etc/liquidsoap
vi /etc/liquidsoap/radio.liq # Edit to your needs
chown -R icecast2:icecast /etc/liquidsoap
chmod 660 /etc/liquidsoap/radio.liq

cp systemd/liquidsoap.service /etc/systemd/system/
systemctl daemon-reload
systemctl enable icecast2
systemctl enable liquidsoap
systemctl start icecast2
systemctl start liquidsoap
```

## Configuration

The configuration file provided in this repository are given as a base you can use for your own server. You are free to modify and adapt them to your needs. You should at least change the passwords.

### IceCast2

The default configuration of IceCast 2 from the default repository is a good starting point. You must change the default passwords if the installation process did not ask you to set them.

### LiquidSoap

The provided configuration makes LiquidSoap stream as a source on a local IceCast server on the `/stream` mountpoint. It will play continuously a playlist in a random order. It's also set up so it will reencode mp3 while streaming. You can also go live by connecting to the configured harbor socket. To further customize this script you can check the official [liquidsoap documentation](https://www.liquidsoap.info/doc-1.4.4/).

## Operating

The whole system is fairly autonomous. It should detect changes in your playlist and apply them on the fly. If the playlist can't be used, it will stream nothing (silence) but won't disconnect from the server.
