+++
Categories = ["Docker", "Raspberry Pi", "ARM"]
Tags = ["Docker", "Raspberry Pi", "ARM"]
date = "2016-03-05T16:04:12+01:00"
draft = false
more_link = "yes"
title = "Run Docker on a Raspberry Pi 3 with onboard WiFi"

+++

Today morning we finally got our Raspberry Pi 3's from ThePiHut. They have been overwhelmed by the number of orders.

![ThePiHut delivery](/images/rpi3-onboard-wifi/thepihut-delivery.jpg)

While waiting for the delivery we already heard from our community that the current HypriotOS SD image does not boot.

But with some little tweaks the first people have started running Docker containers with HypriotOS. We will update our image builder soon and publish a new HypriotOS image for an easy out-of-the-box experience.

<!--more-->

In the meantime for all the impatient out there I'll give you a short intro how to run the latest Docker Engine on the standard Raspbian SD image.

## Download Raspbian LITE
Just download and flash the Raspbian LITE image from https://www.raspberrypi.org/downloads/raspbian/ or use our [`flash` script](https://github.com/hypriot/flash) with this command.

```bash
flash https://downloads.raspberrypi.org/raspbian_lite_latest
```

Now boot your Raspberry Pi 3 and log into it with user `pi` and the password `raspberry`.

```
ssh pi@raspberrypi.local
```

The standard Raspbian image does not resize the SD filesystem automatically.

## Add the overlay kernel module

Before we resize and reboot the Pi we also customize a little bit. The overlay kernel module must be loaded automatically while booting, so we just add it with the next command.

```bash
echo "overlay" | sudo tee -a /etc/modules
```

## Customize WiFi

If you want to run your Docker with the onboard WiFi, just add your SSID and pre-shared key with the next command

```bash
echo 'network={
  ssid="your-ssid"
  psk="your-psk"
}' | sudo tee -a /etc/wpa_supplicant/wpa_supplicant.conf
```

## Resize filesystem

Now we have to resize the filesystem to install Docker and have space for Docker images and containers. Start `raspi-config` and follow the steps to resize your filesystem.

```bash
sudo raspi-config
```

After that let raspi-config reboot your Raspberry Pi.

## Cut the wires

If you have added your WiFi settings, remove your network cable while rebooting. From now on you can connect to your Raspberry Pi 3 over the air.

## Install Docker

After rebooting, eventually unplugging the network cable we have to install Docker. The Raspbian Jessie distribution also has a Docker package, but it is only Version 1.3.3. So we install the Hypriot's Docker 1.10.2 instead.

Just log into your Raspberry Pi 3 again and install Docker with these commands.

```bash
ssh pi@raspberrypi.local
sudo apt-get install -y apt-transport-https
wget -q https://packagecloud.io/gpg.key -O - | sudo apt-key add -
echo 'deb https://packagecloud.io/Hypriot/Schatzkiste/debian/ wheezy main' | sudo tee /etc/apt/sources.list.d/hypriot.list
sudo apt-get update
sudo apt-get install -y docker-hypriot
sudo systemctl enable docker
```

Now you have a good setup until the next HypriotOS release is coming.

![docker version](/images/rpi3-onboard-wifi/rpi3-raspbian-lite-docker-version.png)

And with the onboard WiFi it is now very easy to build some mobile Docker IoT projects.

![docker over the air](/images/rpi3-onboard-wifi/rpi3-over-the-air.jpg)

As always use the comments below to give us feedback and share it on Twitter or Facebook.

Stefan [@stefscherer](https://twitter.com/stefscherer)
