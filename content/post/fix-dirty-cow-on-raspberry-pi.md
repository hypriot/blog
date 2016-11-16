+++
Categories = ["Docker", "Raspberry Pi", "ARM", "HypriotOS", "Raspbian", "DirtyCOW"]
Tags = ["Docker", "Raspberry Pi", "ARM", "HypriotOS", "Raspbian", "DirtyCOW"]
date = "2016-11-01T13:42:20+01:00"
draft = false
more_link = "yes"
title = "Fix Dirty COW on Raspberry Pi the Docker way"

+++

Have you seen the latest reports about the Linux kernel security vulnerability called "Dirty COW"?
Dirty COW is a [race condition in Linux](http://www.theregister.co.uk/2016/10/21/linux_privilege_escalation_hole/) arising from how Copy-On-Write (the COW in the name) is handled by the kernel's memory subsystem's use of private mappings.

The really dangerous point here is, it can be used to [escape Docker containers](http://www.theregister.co.uk/2016/11/01/docker_user_havent_patched_dirty_cow_yet_bad_news/).
![dirty-cow-001](/images/fix-dirty-cow-on-raspberry-pi/dirty-cow-001.jpg)

So, we're encourage you to immediately fix it with upgrading your Linux kernel on the Raspberry Pi !!!

No matter if you're running an official Raspbian or HypriotOS, please upgrade your Linux kernel to be safe again...
<!--more-->


### TL;DR - Fast Fixing

For all the impatient users, here are the essential steps to upgrade your Linux kernel in an easy way on your Raspberry Pi:

**HypriotOS** and **Raspbian Jessie** (more details can be found [here](https://www.raspberrypi.org/blog/#fix-dirty-cow-raspberry-pi))
```
$ sudo apt-get update
$ sudo apt-get install raspberrypi-kernel
$ sudo reboot
```

For both operating systems it requires a system reboot to exchange the running Linux kernel in memory. But once you've done these easy steps you have successfully fixed the Dirty COW vulnerability.


### Testing for Dirty COW with the help of Docker

If you'd like to know whether your system is vulnerable against Dirty COW you can easily run a test with the help of a Docker Image. The complete source code can be found in my Github repo [DieterReuter/rpi-dirtycow](https://github.com/DieterReuter/rpi-dirtycow), so you can build everything on your own, too.

Running this single command is just absolutely easy and this is one of the benefits of Docker, you don't have to install anything on your host machine. Just run a Docker container in a secure way and get instant results within seconds.

Let's do some testing on two different operating systems for the Raspberry Pi:

**Raspbian Jessie LITE (2016-09-23)**

I've used a freshly installed Raspbian Lite for these tests and you can see, we do have a Linux kernel 4.4.21.
```
$ uname -a
Linux raspberrypi 4.4.21-v7+ #911 SMP Thu Sep 15 14:22:38 BST 2016 armv7l GNU/Linux
```

If you don't have the Docker Engine already installed on Raspbian, you can perform it with this few commands - YEAH, it's just so easy.
```
$ curl -sSL https://get.docker.com | bash
$ sudo usermod -aG docker pi
```

Now, logout and login again to get access to the Docker CLI from your default "pi" user.
```
$ docker --version
Docker version 1.12.3, build 6b644ec
```

Once we have Docker installed, we can test against Dirty COW.
```
$ docker run --rm hypriot/rpi-dirtycow
Unable to find image 'hypriot/rpi-dirtycow:latest' locally
latest: Pulling from hypriot/rpi-dirtycow
38070c4d0c33: Pull complete
a3ed95caeb02: Pull complete
2d2e2d46b9b5: Pull complete
Digest: sha256:065d979dd3c48e6488044206ec782628ecf241ef02104610c076949d9881ad0d
Status: Downloaded newer image for hypriot/rpi-dirtycow:latest

Test for Dirty Cow:
  $ echo "You are SAFE!          " > foo
  $ chmod 404 foo
  $ ./dirtyc0w foo "You are VULNERABLE!!!" &
  $ sleep 2
  $ cat foo
You are VULNERABLE!!!
```

Now, let's upgrade the Linux kernel.
```
$ sudo apt-get update
$ sudo apt-get install raspberrypi-kernel
$ sudo reboot
```

And we'll test it again. Hopefully we've fixed it.
```
$ uname -a
Linux raspberrypi 4.4.26-v7+ #915 SMP Thu Oct 20 17:08:44 BST 2016 armv7l GNU/Linux

$ docker run --rm hypriot/rpi-dirtycow

Test for Dirty Cow:
  $ echo "You are SAFE!          " > foo
  $ chmod 404 foo
  $ ./dirtyc0w foo "You are VULNERABLE!!!" &
  $ sleep 2
  $ cat foo
You are SAFE!
```
New Linux kernel 4.4.26 is installed for Raspbian and Dirty COW is fixed!

*Note:* Did you mentioned the different output from the `docker run` commands? The first time, Docker has detected that the Docker Image "hypriot/rpi-dirtycow" is not on the machine and downloads/pulls the required image layers. The second time it can just start the Docker container.


**HypriotOS 1.1.0**

Here I'm using the latest HypriotOS 1.1.0 release, but the Linux kernel upgrade works even for an older 0.8 release.

```
$ uname -a
Linux black-pearl 4.4.24-hypriotos-v7+ #1 SMP PREEMPT Tue Oct 11 17:15:58 UTC 2016 armv7l GNU/Linux
```

Test for Dirty COW.
```
$ time docker run --rm hypriot/rpi-dirtycow
Unable to find image 'hypriot/rpi-dirtycow:latest' locally
latest: Pulling from hypriot/rpi-dirtycow
38070c4d0c33: Pull complete
a3ed95caeb02: Pull complete
2d2e2d46b9b5: Pull complete
Digest: sha256:065d979dd3c48e6488044206ec782628ecf241ef02104610c076949d9881ad0d
Status: Downloaded newer image for hypriot/rpi-dirtycow:latest

Test for Dirty Cow:
  $ echo "You are SAFE!          " > foo
  $ chmod 404 foo
  $ ./dirtyc0w foo "You are VULNERABLE!!!" &
  $ sleep 2
  $ cat foo
You are VULNERABLE!!!

real	0m14.514s
user	0m0.200s
sys	0m0.180s
```

*Note:* You can see, it takes just under 15 seconds to pull the Docker Image and to perform the test against the Dirty COW vulnerability. We didn't installed anything on the host machine for these tests and we can get rid of the Docker image later on and clean our host system easily.

Upgrade the Linux kernel for HypriotOS.
```
$ sudo apt-get update
$ sudo apt-get install raspberrypi-kernel
$ sudo reboot
```

Now, we have the latest Linux kernel 4.4.27 for HypriotOS installed and we're safe again.
```
$ uname -a
Linux black-pearl 4.4.27-hypriotos-v7+ #1 SMP PREEMPT Fri Oct 28 09:06:49 UTC 2016 armv7l GNU/Linux

$ time docker run --rm hypriot/rpi-dirtycow

Test for Dirty Cow:
  $ echo "You are SAFE!          " > foo
  $ chmod 404 foo
  $ ./dirtyc0w foo "You are VULNERABLE!!!" &
  $ sleep 2
  $ cat foo
You are SAFE!

real	0m4.504s
user	0m0.100s
sys	0m0.050s
```

And finally, we'll remove the Docker Image we've used for the tests and free some disk space.
```
$ docker images
REPOSITORY             TAG                 IMAGE ID            CREATED             SIZE
hypriot/rpi-dirtycow   latest              31229be9ea1d        3 days ago          5.512 MB

$ docker rmi -f 31229be9ea1d
Untagged: hypriot/rpi-dirtycow:latest
Untagged: hypriot/rpi-dirtycow@sha256:065d979dd3c48e6488044206ec782628ecf241ef02104610c076949d9881ad0d
Deleted: sha256:31229be9ea1d01ed2df47cc23ab50efdc84be3b49572bb4b6047a449dea4e596

$ docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
```
*Note:* This is another great advantage by Docker - get rid of all the tools we don't need anymore.


### Conclusion: upgrade your system regularly

Your Raspberry Pi system is now SAFE again. In the future don't forget to upgrade it from time to time. On both operating systems, Raspbian and HypriotOS, you can do the upgrade procedure with these few commands:
```
$ sudo apt-get update
$ sudo apt-get upgrade
$ sudo reboot
```

And with this way you'll get some other tools updated as well, like the Docker Engine.
```
$ docker version
Client:
 Version:      1.12.3
 API version:  1.24
 Go version:   go1.6.3
 Git commit:   6b644ec
 Built:        Wed Oct 26 19:06:36 2016
 OS/Arch:      linux/arm

Server:
 Version:      1.12.3
 API version:  1.24
 Go version:   go1.6.3
 Git commit:   6b644ec
 Built:        Wed Oct 26 19:06:36 2016
 OS/Arch:      linux/arm
HypriotOS/armv7: pirate@black-pearl in ~
```
That's all and STAY SAFE !!!


### Feedback, please

As always use the comments below to give us feedback and share it on Twitter or Facebook.

Please send us your feedback on our [Gitter channel](https://gitter.im/hypriot/talk) or tweet your thoughts and ideas on this project at [@HypriotTweets](https://twitter.com/HypriotTweets).

Dieter [@Quintus23M](https://twitter.com/Quintus23M)
