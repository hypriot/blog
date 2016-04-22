+++
Tags = ["Docker", "Raspberry Pi", "ARM", "Hardware"]
date = "2015-12-07T19:55:55+02:00"
title = "The family of ARM hardware for Docker got two more children – at least!"
more_link = "yes"
draft = false
+++

Today we are proud to present a guest contribution from the community. Marcel Großmann, a research assistant at the University of Bamberg, Germany, shows in a short test that the hardware family on which our ARMed Docker runs is probably much larger than we ever thought. But rather than anticipating the punch line, let's give the word to him!

<!--more-->
<br />

## Testing Docker on new Platforms

*(Marcel is now speaking)*

Hello everyone!
First of all, thanks to Hypriot for porting Docker to the ARM platform!

Recently, I tested their port of Docker (v 1.9.1) on two platforms different from the Raspberry Pi and HypriotOS. This time, I had a look at  **[armbian](http://www.armbian.com/)** as operating system, which ships a Linux image based on Debian Wheezy and includes the Vanilla kernel 4.2.6. As hardware I picked the **Cubietruck** and **Lamobo R1** board. The first one, Cubietruck, has e.g. a S-ATA port to attach hard drives and an integrated WiFi and Bluetooth controller:

<img src="http://www.armbian.com/wp-content/uploads/2013/12/cubietruck1.png" alt="" width="600" />


The second one, the Lamobo R1, is also called BananaPi R1. It comes with an integrated 5-port switch fabric and a WiFi modul.


<img src="http://www.armbian.com/wp-content/uploads/2015/08/lamobo-r1.png" alt="" width="600" />

The configuration of both devices shows for `uname -a`:

```
Linux XXX 4.2.6-sunxi #1 SMP Sun Nov 29 10:33:44 CET 2015 armv7l GNU/Linux
```

The Debian release depicted by `lsb_release -a` shows:

```
Distributor ID:	Debian
Description:	Debian GNU/Linux 7.9 (wheezy)
Release:	7.9
Codename:	wheezy
```

To install `docker-hypriot`, I added the Debian package repository of Hypriot to my package manager:

```bash
curl https://packagecloud.io/gpg.key | sudo apt-key add -

sudo bash -c 'cat > /etc/apt/sources.list.d/Hypriot_Schatzkiste.list' << EOF
deb https://packagecloud.io/Hypriot/Schatzkiste/debian/ wheezy main
EOF

sudo apt-get update
sudo apt-get -y install --no-install-recommends docker-hypriot
sudo apt-get -y install cgroupfs-mount

# Add your user to group 'Docker' so you do not need to type `sudo` before each Docker command. 
sudo usermod -aG docker $(whoami)
```

Nevertheless, Docker is not running, if your glibc version is < **2.15**. Test your version with ```ldd --version```. To update glibc, execute these commands:

```bash
sudo bash -c 'echo "deb http://ftp.debian.org/debian sid main" >> /etc/apt/sources.list'
sudo apt-get update
sudo apt-get -yqq -t sid install libc6 libc6-dev libc6-dbg
sudo sed -i "/sid main/s/^/#/g" /etc/sources.list
sudo apt-get clean
sudo apt-get update
sudo reboot
```

After the reboot, `docker version` should show a Docker 1.9.1:
```
Client:
Version:      1.9.1
...
```

In addition, check if your armbian is capable of running Docker with the `check-config.sh` script provided by Docker. Execute the following lines:

```
wget https://raw.githubusercontent.com/docker/docker/master/contrib/check-config.sh
sudo chmod +x check-config.sh
./check-config.sh
```

As output you should see all items in section **Generally Necessary** as **enabled**. Even many options of section **Optional Features** are enabled and thus available. If you wanna see my full output of the script, see [these lines of code](https://gist.github.com/hypriot/5d1236bb9c63f7ef7be8).

Now you may want to install docker-compose, docker-machine or swarm provided by the Hypriot package repository.
<br />
<br />

## The ARMed Family for Docker is probably bigger than that

*(Andreas & Mathias speaking again)*

Many thanks, Marcel. So what's the punch line now? Well, this test makes us believe that **our Docker probably runs on all devices supported by armbian, which is a total of 19 ARM boards!** [See the compatibility list here]( http://www.armbian.com/download/). We now have it safe for two of them. Of course, we are curious who of you has one of the remaining boards at hand and could test it! So, this is our call to the community:

**Who can confirm another ARM board running Docker?**

Get in touch with us via the comments below, on [Twitter](https://twitter.com/HypriotTweets), in the [community chat](https://gitter.im/hypriot/talk) and spread the word using the buttons below.

Andreas, Mathias and Marcel Großmann ([University of Bamberg](https://www.uni-bamberg.de/en/ktr/staff/grossmann-marcel/))
