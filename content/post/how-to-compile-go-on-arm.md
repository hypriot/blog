+++
Categories = ["Docker", "Raspberry Pi", "ARM", "GO", "GOLANG"]
Tags = ["Docker", "Raspberry Pi", "ARM", "GO", "GOLANG"]
date = "2015-12-31T18:47:24+01:00"
draft = false
more_link = "yes"
title = "How to compile Go on any ARM device"

+++

As for today, up to the latest Go version 1.5.2 there is no official binary release
of the Go runtime available for ARM devices. Maybe you can install it as
a package from your operating system, but these packages are almost outdated.

For this reason, anyone who wants to use GOLANG (or Go for short) on an ARM device has to compile
it by himself. This is a cumbersome and time consuming task, which sometimes leads
to bad results.

To cover these issues, we'll explain in this short and basic tutorial how to compile
and test the Go compiler runtime by yourself. We'd like to cover all the details you'll
need from the ground up. And with having this basic understanding then it's easier
for everybody to build and use the Go compiler in a consistent and reproducible way.

So let's get started with building your own Go environment on ARM...

<!--more-->


### Let's Go on ARM

As a member of the Hypriot team I'll show you all the necessary steps on a
Raspberry Pi 2 board. Together we'll first install the operating system with
flashing a SD card with HypriotOS and then installing all the build tools we'll
need to bootstrap a complete Go development environment.

These steps are quite similar for almost every other Linux distro, so I'm assuming you'll
need just a short time to adjust the build steps for any Ubuntu, Debian, ArchLinux
or other Linux OS on your ARM device of choice.


### Bootstrap the building system

We need the following parts:

- a Raspberry Pi 2 Model B
- a SD card with 4Gbyte or larger
- a power adapter or an USB cable to power the Raspberry Pi
- an ethernet cable to connect the Raspberry Pi to the internet

As soon as you have setup the hardware, we can start to install the OS and login
to our fresh and clean build system.

#### a) Flash a new SD card with HypriotOS 0.6.1
I'm using a Mac to flash the SD card, so maybe you have to look for specific
instructions for your OS in one of our other posts.
```
$ wget http://downloads.hypriot.com/hypriot-rpi-20151115-132854.img.zip
$ tar -xvf hypriot-rpi-20151115-132854.img.zip
$ flash --hostname golang-nutshell hypriot-rpi-20151115-132854.img
```

#### b) Boot the Raspberry Pi 2 with HypriotOS
Just insert the SD card into your Raspberry Pi 2, connect the Ethernet cable
between the Raspi and your Internet router/switch and power on the Raspi.

Within one or two minutes the Raspi is booted and has already configured the SD card
for the first time to it's full size. We defined the specific hostname `golang-nutshell`
for the Raspi, so we can lookup the device on our network.
```
$ ping -c 3 golang-nutshell.local

PING golang-nutshell.local (192.168.2.116): 56 data bytes
64 bytes from 192.168.2.116: icmp_seq=0 ttl=64 time=5.337 ms
64 bytes from 192.168.2.116: icmp_seq=1 ttl=64 time=6.142 ms
64 bytes from 192.168.2.116: icmp_seq=2 ttl=64 time=6.781 ms

--- golang-nutshell.local ping statistics ---
3 packets transmitted, 3 packets received, 0.0% packet loss
round-trip min/avg/max/stddev = 5.337/6.087/6.781/0.591 ms
```

#### c) Prepare SSH for login
In case you used the same hostname or IP address before, you should clean your
SSH cache with the following commands:
```
$ ssh-keygen -R golang-nutshell.local
$ ssh-keygen -R 192.168.2.116
```

Now, login to your Raspi with the standard username=`pi` and password=`raspberry`,
or you can optionally just setup SSH with your SSH credentials.
```
$ ssh-copy-id pi@golang-nutshell.local
```

#### d) Login to your Raspberry Pi
Once the Raspi and SSH access is configured, we can login and start working on
our task to compile Go from the source code.
```
$ ssh pi@golang-nutshell.local
```

#### e) Install all the required build dependencies
In order to build Go 1.5 we need first a running Go 1.4 compiler on our system.
So, we'll start our journey with building the Go 1.4 compiler first.

Next we have to consider that Go 1.4.x has to be built with a `gcc` compiler,
because the Go 1.4 compiler is written in C code.

Let's install all the necessary build dependencies. Some of these packages are
already pre-installed with HypriotOS, but I'd like to list all of them here so you
can easily replay this tutorial on a different Linux distro as well.
```
$ sudo apt-get update
$ sudo apt-get install -y curl gcc git-core
```


### Download Go 1.4.3 source tarball and compile it
The GOLANG team provides all the Go sources for all the different versions as
easy to download and install tarballs. But it's not clearly documented how to compile
and package it the right way to get a package for a binary release later on.

Ok, so let's explain these steps in detail and you'll get to know all the important
parts. After all it's just easy to make some mistakes and so we'll try to break
the steps down for easy understanding.

#### a) Download the Go 1.4.3 source code
Maybe some of you will be asking, why I'm extracting the Go source code into the
directory `/usr/local/go` and running the gcc compiler as a `root` user.
I'm coming back later on to the reasons behind, but for now you should know it's just
important for creating the binary package.

You can see, I'm downloading the source tarball and extract it right away in a
single step, but if you like you can break this into two steps as well.
```
$ sudo rm -fr /usr/local/go
$ curl -sSL https://storage.googleapis.com/golang/go1.4.3.src.tar.gz | sudo tar -xz -C /usr/local
```

Alternatively using two steps:
```
$ sudo rm -fr /usr/local/go
$ curl -O https://storage.googleapis.com/golang/go1.4.3.src.tar.gz
$ sudo tar -xzf go1.4.3.src.tar.gz -C /usr/local
```

#### b) Compile Go 1.4.3 without running the tests
We compile Go now from within this installation directory and please we warned
it will take some time. On a Raspberry Pi 2 with it's four ARMv7 cores it's quite fast
enough, but on a slower machine it can take hours!
```
$ cd /usr/local/go/src
$ time sudo ./make.bash

# Building C bootstrap tool.
cmd/dist
...
---
Installed Go for linux/arm in /usr/local/go
Installed commands in /usr/local/go/bin

real	10m41.755s
user	12m8.140s
sys	0m46.860s
```
As soon as we can read the message `Installed Go for linux/arm in /usr/local/go`
we know the build was successful and we can use the Go compiler right away.

#### c) Test running the Go 1.4.3 locally
According to the fact that we used the standard installation path in `/usr/local/go`,
we are now able to use Go 1.4.3 directly on our Raspi. The only thing we need is
to define the PATH variable in order that all the Go tools and programs can be used
from the command line.
```
$ export PATH=/usr/local/go/bin:$PATH
$ go version

go version go1.4.3 linux/arm
```

Great, we do have successfully compiled Go 1.4.3 on our Raspberry Pi and can
use it now right away. This process lasts some time and we don't like to repeat
this much often, right? And on the other side, did you recognized that we didn't
run any tests at all?

Running the Go tests at compile time is quite easy, just run `./all.bash` instead
of `./make.bash`. But this will take way much longer and typically the tests will
fail on a Raspberry Pi 2 and maybe on other similar devices too. In this case it's
better to compile Go an run the tests on a reliable machine like the
[Scaleway](https://www.scaleway.com) cloud servers.


### Package Go 1.4.3 as a binary tarball
Maybe some of you already know, that the GOLANG team is providing Go binary releases
for the most common operating systems. But unfortunately not for ARM.

So let's create our own Go binary tarball in the exact same way like the originals,
because then it's easier for us using the exact same ways and scripts when
we'd like to install it on our new ARM machines as well.

#### a) Analyse the original Go binary tarball
We can find the official GOLANG binary releases on their download page.
So let's just google for "golang download" and we'll get to their website
[Downloads - The Go Programming Language](https://golang.org/dl/) and select
Go 1.4.3 for a Linux on Intel 64-bit.
```
$ curl -O https://storage.googleapis.com/golang/go1.4.3.linux-amd64.tar.gz
```

Now let's analyze the structure of this tarball in more detail.
```
$ tar -vtf go1.4.3.linux-amd64.tar.gz | head -10
drwxr-xr-x 0/0               0 2015-09-23 06:43 go/
-rw-r--r-- 0/0           17575 2015-09-23 06:37 go/AUTHORS
-rw-r--r-- 0/0           24564 2015-09-23 06:37 go/CONTRIBUTORS
-rw-r--r-- 0/0            1479 2015-09-23 06:37 go/LICENSE
-rw-r--r-- 0/0            1303 2015-09-23 06:37 go/PATENTS
-rw-r--r-- 0/0            1112 2015-09-23 06:37 go/README
-rw-r--r-- 0/0               7 2015-09-23 06:38 go/VERSION
drwxr-xr-x 0/0               0 2015-09-23 06:37 go/api/
-rw-r--r-- 0/0             524 2015-09-23 06:37 go/api/README
-rw-r--r-- 0/0           19302 2015-09-23 06:37 go/api/except.txt
```

This tarball has some special settings we should really keep care about it.
First of all, the user and group id's `0/0` are all numeric and showing this
is a `root/root` user.
Next to notice is that the directory name is always starting with `go/` and
without any leading slash `/`.

These are all just small details, but we have to
make sure, we create our own tarball the same way - otherwise it will work on some
machines and on some we'll get some wired issues, because we don't know which
command a different user will use to install the binary tarball on his machine.

#### b) Create our own Go binary tarball
With this details in mind we can create our own binary release tarball easily.
```
$ tar -czf ~/go1.4.3.linux-armv7.tar.gz -C /usr/local go
```
Or alternatively, if your `tar` command does not support the `-C` flag:
```
$ cd /usr/local
$ tar -czf ~/go1.4.3.linux-armv7.tar.gz go
```

#### c) Prove our own Go binary tarball

```
$ tar -vtf go1.4.3.linux-armv7.tar.gz | head -10
drwxr-xr-x root/root         0 2015-12-31 14:06 go/
drwxr-xr-x root/root         0 2015-12-31 14:16 go/bin/
-rwxr-xr-x root/root   7659728 2015-12-31 14:16 go/bin/go
-rwxr-xr-x root/root   2899312 2015-12-31 14:16 go/bin/gofmt
-rw-r--r-- root/root      1303 2015-09-23 06:37 go/PATENTS
-rw-r--r-- root/root      1479 2015-09-23 06:37 go/LICENSE
drwxr-xr-x root/root         0 2015-09-23 06:38 go/test/
-rw-r--r-- root/root       722 2015-09-23 06:37 go/test/sinit_run.go
-rw-r--r-- root/root      2280 2015-09-23 06:37 go/test/nil.go
-rw-r--r-- root/root       716 2015-09-23 06:37 go/test/typeswitch3.go
```
Ok, not exactly the same as the original. The user and group id's are not in numerical form, but all the other details seems to be correct. We just have to include the `--numeric-owner` flag and we'll get a perfect result.

#### d) Recommended way to package the Go binary tarball
With all the details proved well, we do have now a way how we should package the
Go pre-compiled binary tarball. As long as your ARM Linux system supports the `tar`
command with all the necessary flags, we can use this single command line:
```
$ tar --numeric-owner -czf ~/go1.4.3.linux-armv7.tar.gz -C /usr/local go
```

It can happen that your `tar` version doesn't support the `--numeric-owner` flag,
so just leave this out. When your `tar` doesn't support the `-z` compresssion flag,
it can be done in two steps as well. And if `-C` flag isn't supported, we can
work around this too.
```
$ cd /usr/local
$ tar --numeric-owner -cf ~/go1.4.3.linux-armv7.tar go
$ gzip ~/go1.4.3.linux-armv7.tar
```

And finally, here is our almost perfect own-built pre-compiled Go tarball, which
we could install within just seconds on any of our ARM devices.
```
$ tar -vtf go1.4.3.linux-armv7.tar.gz | head -10
drwxr-xr-x 0/0               0 2015-12-31 14:06 go/
drwxr-xr-x 0/0               0 2015-12-31 14:16 go/bin/
-rwxr-xr-x 0/0         7659728 2015-12-31 14:16 go/bin/go
-rwxr-xr-x 0/0         2899312 2015-12-31 14:16 go/bin/gofmt
-rw-r--r-- 0/0            1303 2015-09-23 06:37 go/PATENTS
-rw-r--r-- 0/0            1479 2015-09-23 06:37 go/LICENSE
drwxr-xr-x 0/0               0 2015-09-23 06:38 go/test/
-rw-r--r-- 0/0             722 2015-09-23 06:37 go/test/sinit_run.go
-rw-r--r-- 0/0            2280 2015-09-23 06:37 go/test/nil.go
-rw-r--r-- 0/0             716 2015-09-23 06:37 go/test/typeswitch3.go
```


### Install and test the Go 1.4.3 binary tarball
Honestly, this was a long and dirty road, just to get a Go 1.4.3 compiler so that
we can start developing our Go code and compiling our real world tasks on an
ARM device. But with all these details we know now exactly how to create and package
a Go binary release as a pre-compiled tarball.

And finally, let's see how easy we do have it now, when we have a Go binary release
for our ARM device available. It's really that damn simple to install Go and just using it.
```
$ sudo rm -fr /usr/local/go
$ sudo tar -xzf go1.4.3.linux-armv7.tar.gz -C /usr/local
$ export PATH=/usr/local/go/bin:$PATH
$ go version

go version go1.4.3 linux/arm
```


### Compiling, testing and packaging Go 1.5.2
With all our previous detailed work this part is now a really easy task.

As the first step, before we're able to compile Go 1.5.2 on our ARM board, we have
to install a Go 1.4.3 compiler. Luckily we have already a pre-compiled Go 1.4.3
which we can use here. But we should install it in a different location, which is
the recommended way according to the GOLANG team.

Install the Go 1.4.3 binary release from our own tarball:
```
$ rm -fr $HOME/go1.4
$ mkdir -p $HOME/go1.4
$ tar -xzf go1.4.3.linux-armv7.tar.gz -C $HOME/go1.4 --strip-components=1
```

Now we can download the Go 1.5.2 source tarball and bootstrap/compile it with Go 1.4.3:
```
$ sudo rm -fr /usr/local/go
$ curl -sSL https://storage.googleapis.com/golang/go1.5.2.src.tar.gz | sudo tar -xz -C /usr/local

$ cd /usr/local/go/src
$ time sudo GOROOT_BOOTSTRAP=/home/pi/go1.4 ./make.bash

##### Building Go bootstrap tool.
...
---
Installed Go for linux/arm in /usr/local/go
Installed commands in /usr/local/go/bin

real	11m14.203s
user	26m29.730s
sys	1m18.470s
```

Let's package Go 1.5.2 as a binary tarball, using our recommended way:
```
$ tar --numeric-owner -czf ~/go1.5.2.linux-armv7.tar.gz -C /usr/local go
```

Prove the Go 1.5.2 binary package:
```
$ tar -vtf go1.5.2.linux-armv7.tar.gz | head -10
drwxr-xr-x 0/0               0 2015-12-31 17:08 go/
drwxr-xr-x 0/0               0 2015-12-31 17:18 go/bin/
-rwxr-xr-x 0/0         9004984 2015-12-31 17:18 go/bin/go
-rwxr-xr-x 0/0         3163768 2015-12-31 17:17 go/bin/gofmt
-rw-r--r-- 0/0            1519 2015-12-03 01:52 go/README.md
-rw-r--r-- 0/0            1303 2015-12-03 01:52 go/PATENTS
-rw-r--r-- 0/0            1479 2015-12-03 01:52 go/LICENSE
drwxr-xr-x 0/0               0 2015-12-03 01:53 go/test/
-rw-r--r-- 0/0             595 2015-12-03 01:53 go/test/sinit_run.go
-rw-r--r-- 0/0            2280 2015-12-03 01:53 go/test/nil.go
```

Install and test the Go 1.5.2 binary tarball
```
$ sudo rm -fr /usr/local/go
$ sudo tar -xzf go1.5.2.linux-armv7.tar.gz -C /usr/local
$ export PATH=/usr/local/go/bin:$PATH
$ go version

go version go1.5.2 linux/arm
```

Wow, this time it was pretty easy and completed with a few commands only.
But we didn't run any tests at all. And honestly, as a developer I just like
to install and use the Go compiler - I don't like to compile it by myself,
so I recommend using a Go binary release would be the best way!


### Key takeaways
As you can clearly see, it's really the easiest and preferred way to install a
Go binary release instead of compiling the Go compiler every time from source.
Especially for some slow ARM devices it can take hours and will sometimes lead
to some confusing problems too.

When you prefer to use a completely tested Go binary release it's even more desired
to use pre-compiled and successfully tested Go versions for ARMv6, ARMv7 and
even later for the 64-bit ARM devices as well.

The really great news here is, that  the GOLANG team has acknowleged to build
and deliver the future Go releases from version 1.6 on with pre-compiled tarballs - at least
for ARMv6. The difference between ARMv6 and ARMv7 are absolutely marginal for Go,
because the generated machine code doesn't use any advanced instructions from the
ARMv7 instruction set at all and ARMv7 just uses a few more registers - that's all.

And in the meantime, we've already done all the hard work for you and created the
Go binary releases for 1.4.3, 1.5.1 and 1.5.2. Everything is open source and
available on our GitHub repo at https://github.com/hypriot/golang-armbuilds. From
here you can easily install a Go binary release within a few minutes with the following commands:
```
$ sudo rm -fr /usr/local/go
$ curl -sSL https://github.com/hypriot/golang-armbuilds/releases/download/v1.5.2/go1.5.2.linux-armv7.tar.gz | sudo tar -xz -C /usr/local
$ export PATH=/usr/local/go/bin:$PATH
$ go version

go version go1.5.2 linux/arm
```
This is already a work in progress and we're happy to get comments and pull-request
to improve the build task even more.


### Feedback please!

Please send us your feedback on our [Gitter channel](https://gitter.im/hypriot/talk) or tweet your thoughts and ideas on this tutorial at [@HypriotTweets](https://twitter.com/HypriotTweets).

Dieter [@Quintus23M](https://twitter.com/Quintus23M)
