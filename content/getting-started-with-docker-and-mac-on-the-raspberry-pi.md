+++
Categories = ["docker"]
Description = "How to get Docker running on your Raspberry Pi using Mac OS X"
Tags = ["hypriotos", "docker", "arm", "raspberry_pi", "getting_started", "mac"]
title = "How to get Docker running on your Raspberry Pi using Mac OS X"
date = "2015-05-15T20:16:11+02:00"
disqus = "yes"
social_sharing = "yes"
+++

This guide shows you how to get Docker running on your Raspberry Pi using a **Mac OS X workstation**.

> If you have not read the getting started guide about Docker on the Raspberry Pi yet you might wanna check it out first: [Getting started with Docker on your ARM Device](/getting-started-with-docker-on-your-arm-device)

We tried to make this guide as concise as possible. Make sure that you know the basics about the command line and you should be ready to go.
If you don't you can learn the basics in [An Introduction to the Linux Terminal](https://www.digitalocean.com/community/tutorials/an-introduction-to-the-linux-terminal) and come back afterwards.

The **hardware** you gonna need to follow along is a Raspberry Pi 1 or 2 and one SD card.
If you are going to use a Raspberry 2 you will have to use a microSD card - otherwise a normal SD card is sufficient.
We recommend a size of at least 4 GB.

The SD card contains all the software which we are going to use on our Raspberry Pi.
With software we basically mean two things: first an operating system for your Raspberry Pi and second the software you as user would like to use - e.g. a browser or a word processing program.
In our case the software we wanna use is Docker.

We - from Hypriot - created a preconfigured [SD card image](http://blog.hypriot.com/downloads/) which contains everything you need to run Docker on your Raspberry Pi.
To use the image you first have to download and transfer it to your SD card. Transferring an image to an SD card is often referred to as *flashing*.
Afterwards you just have to insert the flashed SD card into your Raspberry Pi and start it up.

### Download the Hypriot Docker SD card image
Download our latest SD card image from the [download page](http://blog.hypriot.com/downloads/).

After the download is completed open a terminal window. To do this press **CMD** + **Whitespace** and type *terminal*.

Now we will extract the downloaded zip file. Go to your *Download* folder first by typing

```
cd ~/Downloads
```

Now extract the zip file with

```
unzip hypriot-rpi-201???.img.zip
```

After the file is unzipped you will have a new file with an **.img** extension.
In the next step we will flash this file onto your SD card.

### Flash the downloaded image to your SD card
First put your SD card into the computer. Then in the terminal type

```
diskutil list
```

You should see a list of all your disks like this:

![disktuil-list](https://s3.eu-central-1.amazonaws.com/assets.hypriot.com/blog_post_getting-started/mac-screenies/diskutil-list.png)


Now identify the SD card. Look at the fourth column which shows the size of the devices of your workstation.
One item in the list should have a size that is very close to the size of your SD card.
From there get the identifier which is shown in the first column.
Here the identifier is `/dev/disk5`.

Now unmount the SD card. Make sure to replace `/dev/disk5` with the identifier of your sd card.

```
diskutil unmountdisk /dev/disk5
```

As a result you should see

![Screenshot unmounted](https://s3.eu-central-1.amazonaws.com/assets.hypriot.com/blog_post_getting-started/mac-screenies/unmount.png)

Now we are ready to flash the SD card. We are going to use the `dd` command for this.

Before you execute the command below, make sure to

- replace the parameter after `if=` with the path to the downloaded image
- replace the parameter after `of=` with the identifier of your SD card. Make sure you put a `r` in front of `disk` as you can see in the example

```
sudo dd if=hypriot-rpi-201???.img of=/dev/rdisk5 bs=1m
```

While this command is executed you won't get any information about its progress.
Depending on your hardware and the performance of your SD card it can take up to five minutes to flash the image.
When the `dd` is finished, you should get an output like this:

![after-dd-success](https://s3.eu-central-1.amazonaws.com/assets.hypriot.com/blog_post_getting-started/mac-screenies/dd-success.png)

Finally unmount the SD card again in the same way as before.

### Start your Raspberry Pi with the SD card
Boot your Raspberry Pi by

- connecting the Raspberry Pi to your local network via an ethernet cable
- putting the SD card into the designated slot
- plugging in the power adapter

After finishing the last step your Raspberry Pi will boot and the LEDs should start blinking.
The very first boot will take one to three minutes as the file system will be resized.

### Ensure everything works
To check if Docker is actually running we need to log into the Raspberry Pi.

To do this we need to find out the IP address of your Raspberry Pi first.
If you are not sure what the IP-Address of your PI is, there are different ways of finding it out.
One way is to use the `nmap` command.

First identify the IP address of your own workstation. Type

```
ipconfig getifaddr en1
```
If it does not report back an IP address, you are probably connected via cable to your network. Try `en0` instead of `en1`.

As you can see in the following screenshot our IP address is `192.168.0.101`.

![own-ip-address](https://s3.eu-central-1.amazonaws.com/assets.hypriot.com/blog_post_getting-started/mac-screenies/own-ip-address.png)

Then replace the IP address in front of the `/24` with yours and type

```
nmap -sP 192.168.0.100/24 | grep black-pearl
```

The output of the `nmap` command should show you the IP address of your Raspberry Pi.
If you get a blank line without an IP address your Raspberry Pi is probably not connected to the network.
Or there is a problem with the SD card which prevents the Raspberry Pi from booting.

After you found out the IP address establish a connection to the Raspberry Pi with the ssh command.
Replace the IP address after the `@` with the one of your Raspberry Pi.

```
ssh pirate@192.168.178.10
```

When you are asked for the password type `hypriot` and hit *Enter*.

The first time you establish the connection you will be asked if you are sure that you want to connect to the Raspberry Pi - answer with `yes`.

If everything went fine you should now see the *HypriotOS* command line prompt waiting for your input.

![hypriot-ssh-prompt-after-login](https://s3.eu-central-1.amazonaws.com/assets.hypriot.com/blog_post_getting-started/mac-screenies/hypriot-ssh-prompt-after-login.png)


Finally check if the Docker Service is running by typing

```
docker info
```

The output of the `docker info` command should look similar to:

![docker-info](https://s3.eu-central-1.amazonaws.com/assets.hypriot.com/blog_post_getting-started/mac-screenies/docker-info.png)


**Congratulations! You have succeeded in getting Docker running on your Raspberry Pi!** :)

You are now ready to continue your exploration of Docker with our [Getting Started Guide](/getting-started-with-docker-on-your-arm-device#going-wild-with-docker-what-can-you-actually-do-with-it:397c66ef19f9f061b6711d2e296cb276).

Have fun!
