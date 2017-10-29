+++
Categories = ["Docker", "Raspberry Pi", "ARM", "ARM64"]
Tags = ["Docker", "Raspberry Pi", "ARM", "ARM64", "External", "cloud-init", "rpi-64"]
Description = "Bootstrapping a Cloud with Cloud-Init and HypriotOS"
date = "2017-10-29T00:14:00-07:00"
more_link = "yes"
title = "Bootstrapping a Cloud with Cloud-Init and HypriotOS"
disqus = "yes"
social_sharing = "yes"

+++

> Things may come to those who wait, but only the things left by those who hustle.

Over the last year, a lot has happened in the Raspberry Pi and Docker communities, there are Docker Captains helping lead the charge, one of those, [Dieter Reuter](https://twitter.com/Quintus23M) really has been pushing the cause for ARM64 support with both Raspberry Pi 3 and LinuxKit. He isn't a single man army, the rest of the [Docker Pirates](http://blog.hypriot.com/crew/) over at [Hypriot](http://blog.hypriot.com/) has been doing some awesome things as well!

Building on the backs of these outstanding community members, I was finally able to spin up a Raspberry Pi, exactly like I do in the "real world", just turn it on, let it self-configure, then software just runs.

<!--more-->

A lot of this is really about having [cloud-init ](http://cloudinit.readthedocs.io/en/latest/index.html) available in the HypriotOS 64bit images thanks to another Pirate [Stefan Scherer](https://twitter.com/stefscherer). In the "cloud world", you spin up instances, give it some user-data, then when it boots, the machines self-configures based on the instance meta-data and the user-data provided.

## Before

Before we talk about the "new" pirate way, let't talk about the "old" non-pirate way.

* Download Raspbian Lite (the easiest for nubbies like me)
* Flash said image to an SD Card
* Optionally re-mount SD Card and monkey some stuff around
* Put the card in your RPi
* Power up the RPi
* If you don't have avahi/bonjour, go find the IP in your router
* SSH into the server
* Update Packages
* Run `raspi-config` and modify some junk
* Reboot
* Install Docker
* Initialize Docker Swarm
* Configure [Portainer](http://portainer.io) service (if not, are you broken?)
* "try" and find some images you can run on arm
* Cheer at your glory based nginx hello world page!
* Figure out how to use automation tools like Ansible to make your life easier when you need a cluster
* Bang head on desk learning so much...
* Do victory dances when you created a bunch of automation around setting up servers
* Go find out what the community is doing

It is at that point, when the community really is an awesome place. Given the latest [HypriotOS-rpi64](https://github.com/DieterReuter/image-builder-rpi64/releases/tag/v20171013-172949), the [flash](https://github.com/hypriot/flash) utility (also from Hypriot), Docker images now being multi-architecture supported through the [manifest v2 API](https://github.com/docker/distribution/blob/master/docs/spec/manifest-v2-2.md) and Docker pushing to get all the [supported images covering a lot of architectures](https://github.com/docker-library/official-images#architectures-other-than-amd64), life begins to get much **much** easier.

---
**DISCLAIMER**: Before we continue, we need to talk about ARM 64 naming issues.

[ARM is complicated](https://en.wikipedia.org/wiki/ARM_architecture#64.2F32-bit_architecture) when it comes to the latest version of the architecture (v8). A lot of the distros still haven't settled on what to call it, and you will find a lot of differences: `AArch64` and `ARM64v8` being the two most popular. When in doubt, do what [Docker does](https://github.com/docker-library/official-images#architectures-other-than-amd64).

---

## After

Now that we got that out of the way, let's get into some code. Given the list of `arm64v8` images in the [Docker registry](https://hub.docker.com/u/arm64v8/) I wanted to find something that would be interesting. Luckily, I was able to find [NextCloud](https://nextcloud.com/). I have no idea if this software is worth keeping around, but it was something I could play with, try to break, reboot to see if it lives, and have something to play with when I succeed!

### User Data

The first thing we need to do, is create our `user-data` file. This will be placed inside of our SD card when we flash it and instruct `cloud-init` what to do when the system boots for the first time. 

It should be noted, that at this time, the cloud-init version available for Debian distribution is [0.7.9](http://cloudinit.readthedocs.io/en/0.7.9/), not the 17.1 you would have thought (as latest). Currently only Ubuntu is the only distribution I know of that is using 17.1. 

The next important fact to know is that the Data Source we are utilizing is the [NoCloud](http://cloudinit.readthedocs.io/en/0.7.9/topics/datasources/nocloud.html) data source. This basically means (in the 0.7.9 and below version) that the `user-data` and `meta-data` are on the local file system, not pulled from a remote resource or other means.

The `user-data` file is simply a YAML file, you can get a lot more complicated, but for the sake of simplicity, let's just call it a YAML file. 

The `user-data` for this project:

```yaml
#cloud-config
# vim: syntax=yaml
#

hostname: nextcloud-pi64
manage_etc_hosts: true

resize_rootfs: true
growpart:
    mode: auto
    devices: ["/"]
    ignore_growroot_disabled: false

users:
  - name: pirate
    gecos: "Hypriot Pirate"
    sudo: ALL=(ALL) NOPASSWD:ALL
    shell: /bin/bash
    groups: users,docker,video
    plain_text_passwd: hypriot
    lock_passwd: false
    ssh_pwauth: true
    chpasswd: { expire: false }

package_update: true
package_upgrade: true
package_reboot_if_required: true
packages:
  - ntp

locale: "en_US.UTF-8"
timezone: "America/Los_Angeles"

write_files:
    - path: "/etc/docker/daemon.json"
      owner: "root:root"
      content: |
        {
          "labels": [ "os=linux", "arch=arm64" ],
          "experimental": true
        }

runcmd:
  - [ systemctl, restart, avahi-daemon ]
  - [ systemctl, restart, docker ]
  - [docker, swarm, init ]
  - [
      docker, service, create, 
      "--detach=false", 
      "--name", "portainer", 
      "--publish", "9000:9000", 
      "--mount", "type=volume,src=portainer_data,dst=/data", 
      "--mount", "type=bind,src=//var/run/docker.sock,dst=/var/run/docker.sock", 
      "portainer/portainer", "-H", "unix:///var/run/docker.sock", "--no-auth"
    ]
  - [mkdir, "-p", "/var/cloud/data" ]
  - [setfacl, "-m", "u:www-data:rwx", "/var/cloud/data" ]
  - [
      docker, service, create, 
      "--detach=false", 
      "--name", "nextcloud", 
      "--publish", "80:80", 
      "--mount", "type=volume,src=nextcloud,dst=/var/www/html", 
      "--mount", "type=bind,src=//var/cloud/data,dst=/var/www/html/data", 
      "--env", "SQLITE_DATABASE=nextcloud", 
      "--env", "NEXTCLOUD_ADMIN_USER=pirate", 
      "--env", "NEXTCLOUD_ADMIN_PASSWORD=hypriot", 
      "nextcloud:latest" 
    ]
```

It is extremely important that before you flash this to a disk and attempt to boot, that you run this file through a YAML linter. There are some good ones [available online](http://www.yamllint.com/), but you should never use an online linter if your `user-data` contains real passwords or SSH keys, you can't trust if they store the YAML or not on the server side.

Now, let's break this down into somewhat readable chunks...

#### Configure Host Name

This will simply configure your hostname of the machine as well as make sure that `/etc/hosts` is appropriately updated. You can specify an `fqdn` here, as you will see below. However, the hostname in this file isn't super important, as we will use the `--hostname` option with the flash utility later to change this when we write the image.

```yaml
hostname: nextcloud-pi64
manage_etc_hosts: true
```

#### Resize File System

This is something that had plagued RPi users for years, finally at some point the foundation images included this on first boot, but the wonderful thing about `cloud-init` is it already had this built in. You "really" don't need these settings in the file, I put these here to show that this is just built in functionality for `cloud-init`.

```yaml
resize_rootfs: true
growpart:
    mode: auto
    devices: ["/"]
    ignore_growroot_disabled: false
```

#### Create Users

Creating users is pretty simple, plop in an array element, give it some information, and your off to the races. The below is actually what is in the default `cloud-init` for the HypriotOS image if you don't overwrite it.  You can actually do a lot more with this, including adding SSH keys. Check out the [users documentation](http://cloudinit.readthedocs.io/en/0.7.9/topics/modules.html#users-and-groups)

```yaml
users:
  - name: pirate
    gecos: "Hypriot Pirate"
    sudo: ALL=(ALL) NOPASSWD:ALL
    shell: /bin/bash
    groups: users,docker,video
    plain_text_passwd: hypriot
    lock_passwd: false
    ssh_pwauth: true
    chpasswd: { expire: false }
```

#### Update and Add Packages

Because we live in a world of ever updating software, you really don't know what is out of date in your image. This ensures that on first boot, all packages are updated. Additionally, you can install additional packages you might need. In this case I am installing NTP (there is a better way to do this, but there is an outstanding issue with it atm). Additionally, we instruct `cloud-init` to reboot the server if the updates require one.

```yaml
package_update: true
package_upgrade: true
package_reboot_if_required: true
packages:
  - ntp
```

NTP missing from the HypriotOS image is something I will be bringing up with the team to get fixed in the future!

#### Set Localized Settings

These will setup your server in your correct part of the world. The Raspbian comes with UK as default, at least HypriotOS came with a sane UTC default, but sometimes you just want your local time. This is definitely one of those time savers where most people used `raspi-config` to set these (horrible horrible menus).

```yaml
locale: "en_US.UTF-8"
timezone: "America/Los_Angeles"
```

This is something I feel like you should also be able to configure in the flash utility, and will be bringing it up as well with the Pirates.

#### Write some arbitrary files

The power to create files on boot... This simple file output below is configuring docker labels as well as doing the (currently required) experimental features flag. This will require a Docker daemon restart, but we will cover that soon enough!

```yaml
write_files:
    - path: "/etc/docker/daemon.json"
      owner: "root:root"
      content: |
        {
          "labels": [ "os=linux", "arch=arm64" ],
          "experimental": true
        }
```

#### Run a bunch of commands

There are actually a few ways to run commands in `cloud-init`, this is the most used, because it is the last thing that is done during initialization.

In this, we are essentially restarting Docker and avahi to pickup our configuration changes, initializing Docker Swarm, running good ol Portainer (so we can see what is going on without SSH).

The last steps are all specific to NextCloud. I create a new directory to store the files and SQL Lite database, set permissions for the `www-data` user since NextCloud is using Apache, and running as a known user, we need to give that specific user permissions, and finally bootstrap NextCloud to self-configure and initialize.

```yaml
runcmd:
  # Pickup the hostname changes
  - [ systemctl, restart, avahi-daemon ]
  
  # Pickup the daemon.json changes
  - [ systemctl, restart, docker ]
  
  # Init a swarm, because why not
  - [docker, swarm, init ]
  
  # Run portainer, so we can see our logs and control stuff from a UI
  - [
      docker, service, create, 
      "--detach=false", 
      "--name", "portainer", 
      "--publish", "9000:9000", 
      "--mount", "type=volume,src=portainer_data,dst=/data", 
      "--mount", "type=bind,src=//var/run/docker.sock,dst=/var/run/docker.sock", 
      "portainer/portainer", "-H", "unix:///var/run/docker.sock", "--no-auth"
    ]

  # Create a specific directory to store all the data, 
  # this way you could mount an external drive later (coming soon!)
  - [mkdir, "-p", "/var/cloud/data" ]

  # This gives the nextcloud permissions to write to this directory 
  # since it runs as www-data
  - [setfacl, "-m", "u:www-data:rwx", "/var/cloud/data" ]

  # Create the nextcloud instance configuring it on startup 
  # - you should change the user/password below to something less obvious 
  # or use the config UI
  - [
      docker, service, create, 
      "--detach=false", 
      "--name", "nextcloud", 
      "--publish", "80:80", 
      "--mount", "type=volume,src=nextcloud,dst=/var/www/html", 
      "--mount", "type=bind,src=//var/cloud/data,dst=/var/www/html/data", 
      "--env", "SQLITE_DATABASE=nextcloud", 
      "--env", "NEXTCLOUD_ADMIN_USER=pirate", 
      "--env", "NEXTCLOUD_ADMIN_PASSWORD=hypriot", 
      "nextcloud:latest" 
    ]
```

There are some important bits here, the `SQLITE_DATABASE=<name>` is actually what triggers the "auto-configure" option, without that, the `NEXTCLOUD_*` variables are ignored, despite what the documentation says.

### FLASH

If you don't know about this utility yet, please head over to the [github repo](https://github.com/hypriot/flash) and check it out.

Good, your back, now lets see my command line I use to run this on my Ubuntu 16.x Server.

The following statements will install the prerequisites for flash, download the script, download this blog posts `user-data.yml` file, then attempt to flash the image to an SD card.

I highly recommend using a 32 or 64 GB flash card for this project, because if you decide to keep this cloud around, you might want to store one or two things in it.

When prompted, insert your SD flash card into an available USB slot, then choose the right one, and verify the right one. You really don't want DD to mount/flash/unmount your main drive.

```bash
sudo apt-get install pv unzip hdparm
curl -O https://raw.githubusercontent.com/hypriot/flash/master/$(uname -s)/flash
chmod +x flash
sudo mv flash /usr/local/bin/flash

# Just make sure the existing is gone
rm ./user-data.yml

# Download this yaml from this repo
curl -O https://gist.githubusercontent.com/RenEvo/6a9e244b670df334c42578b8fe95400b/raw/user-data.yml

// flash it
flash \
  --hostname mycloud.home.renevo.com \
  --userdata ./user-data.yml \
  https://github.com/DieterReuter/image-builder-rpi64/releases/download/v20171013-172949/hypriotos-rpi64-v20171013-172949.img.zip
```

When finished, pull out that sweet SD card, and let's get ready to plug in.

### Boot and Forget

For this, I simply put the SD card into a random RPi3 I had laying around, plugged in a network cable to my switch and the RPi, and then applied power to it.

This is really where the waiting game begins, the RPi is going to boot up, self-name, self-update, possible reboot, pull down some Docker images, bootstrap a Docker Swarm, run Portainer, then finally... start a personal cloud.

At the time of writing this, you are still going to have to go fish out your IP from DNS unless you are on Mac or Linux with avahi, at that case, you can just navigate to `http://<hostname>.local` or `http://<hostname>` if you used an fqdn like I did. There are actually ways to get the RPi to phone home when it is finished bootstrapping, but I am going to save that for another post!

So, after you get some coffee, you can try navigating to your RPi on port 9000 with your browser, that should get you into the Portainer instance without any type of authentication (don't do this in a real environment please, go read the docs on securing it).

After you go get a snack and take a short walk, you can try navigating to your RPi on port 80 with your browser, once you get prompted, login with user: `pirate` and password: `hypriot` to get access to your cloud. Click close on the annoying modal about downloading sync programs, and there you have it... Your own personal cloud, bootstrapped from a simple YAML file, without you ever having to SSH into your PI. 

Here is the fun part, you can reflash that anytime you want to recreate the exact same baseline SD card image.

## Summary

This was a lot of fun for me, and without having to actually figure out some nitty gritty details, not over documenting things, and getting prepared to write this post, it realistically took me about 10 minutes to go from downloading the OS image to running NextCloud on my RPi. And that is all due to the hard work of the community, and especially the Docker Pirates at Hypriot, and to them, I thank you.

I plan to continue playing with this, potentially updating the server to use an external USB drive for data and auto-mounting it on boot, possible setup a GlusterFS and run them in a small 2 or 3 node cluster, and call it my PiCloud. 

Who knows, it's all about having fun and experimenting right?

All the samples can be [found on on GitHub](https://gist.github.com/RenEvo/6a9e244b670df334c42578b8fe95400b).

## About Me

> Who is this guy, and why is he posting on this blog?

My name is [Tom Anderson](https://twitter.com/TribalTom), I am a Senior II Cloud Software Engineer by day at a killer gaming company, and by night I am a father, musician, tinkerer, and still... a hobbiest programmer of all the things. Dieter Reuter was nice enough to ask me to guest post this topic, and I just felt it had to be done! The Pirates have given so much to the community, I felt I needed to give a little something back.

Additionally, I build and talk about some things I think are cool on my own blog [tomanderson.me](http://tomanderson.me), feel free to stop by and say hi!

Finally, because legaleeze and stuff... All opinions here are my own, and do not reflect the opinions of Blizzard Entertainment.
