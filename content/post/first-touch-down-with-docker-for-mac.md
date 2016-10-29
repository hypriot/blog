+++
Categories = ["Docker", "Docker for Mac", "Mac", "OSX", "Raspberry Pi", "ARM"]
Tags = ["Docker", "Docker for Mac", "Mac", "OSX", "Raspberry Pi", "ARM"]
date = "2016-03-27T18:30:29+02:00"
draft = false
more_link = "yes"
title = "First Touch Down with Docker for Mac"

+++

A few days ago, Docker has announced a closed BETA program for their new
applications "Docker for Mac" and "Docker for Windows". These apps are meant to
simplify the usage of Docker containers for every developer even more. They try
to lower the barrier to install and use Docker on your desktop and laptop computers
for both Mac and Windows users.

As soon as I received the first rumors that there is a special feature built-in,
which should also simplify the developers workflow for IoT applications, I was getting
totally thrilled and registered immediately for the BETA program. It was really hard
to wait for, but luckily I've received an email with my BETA invitation and access
token within a few hours only.

Here I'd like to give you a first insight view how to install and use "Docker for Mac"
with a basic walk-through on my MacBook Pro running the very latest OS X 10.11.4.

![Docker for Mac](/images/first-touch-down-with-docker-for-mac/docker4mac-copy-app.jpg)

So, please join me on this journey...

<!--more-->


## Access to the BETA program

You can easily register to the Docker BETA program at https://beta.docker.com. Once
you're logged in with your Docker ID (which is literally your Docker Hub user account)
you can apply for testing "Docker for Mac" and "Docker for Windows".

![Docker for Mac](/images/first-touch-down-with-docker-for-mac/docker4mac-apply-for-beta.jpg)

As this is a closed BETA, you'll get on a waiting list and hopefully will be selected
soon. So, please be patient until you'll receive an invitation email with some more
detailed instructions and a personal access key.

For this blog post, I'll show you how easy it is to install and use Docker on OS X.
And I guess, we'll write another post later for all the curious Windows users,  too.


## Download and install "Docker for Mac"

When you're selected for the BETA, you'll receive an email titled "Docker Private Beta"
with a link to the download page and an access key.

![Docker for Mac](/images/first-touch-down-with-docker-for-mac/docker4mac-download-page.jpg)

Download the installer package called "Docker.dmg" to your Mac and double click it,
drag and drop the "Docker beta" app to your Applications folder.

![Docker for Mac](/images/first-touch-down-with-docker-for-mac/docker4mac-copy-app.jpg)

Now, from your Lauchpad you can start the "Docker beta" app directly the first time
and you can begin right away using Docker on your Mac.

![Docker for Mac](/images/first-touch-down-with-docker-for-mac/docker4mac-start-app.jpg)

Once you start the BETA Docker app the first time you'll be asked to enter your
personal invite token.
![Docker for Mac](/images/first-touch-down-with-docker-for-mac/docker4mac-install-01-insert-key.jpg)

Token has been accepted.
![Docker for Mac](/images/first-touch-down-with-docker-for-mac/docker4mac-install-02-key-accepted.jpg)

The Docker app needs to additionally install a network helper and requests for privileges
to do so.
![Docker for Mac](/images/first-touch-down-with-docker-for-mac/docker4mac-install-03-request-privileges.jpg)

Enter your credentials to grant privileged access.
![Docker for Mac](/images/first-touch-down-with-docker-for-mac/docker4mac-install-04-grant-privileges.jpg)

Success, the Docker app is installed and you can easily find and access it by
clicking on the little neat whale icon.
![Docker for Mac](/images/first-touch-down-with-docker-for-mac/docker4mac-install-05-tray-icon.jpg)


## Using "Docker for Mac" the first time

To use Docker we'll just start a terminal window and use the Docker CLI to access
the local Docker Engine.

First, get the version of the Docker command:
![Docker for Mac](/images/first-touch-down-with-docker-for-mac/docker4mac-run-docker-01-dash-v.jpg)

Determine the versions of the Docker Client and the Docker Engine:
![Docker for Mac](/images/first-touch-down-with-docker-for-mac/docker4mac-run-docker-02-version.jpg)

Display some more detailed informations about the installed Docker software:
![Docker for Mac](/images/first-touch-down-with-docker-for-mac/docker4mac-run-docker-03-info.jpg)


## Let's start a real Docker container

First, we'll check how our host operating system looks like:
```
uname -a
Darwin demo.local 15.4.0 Darwin Kernel Version 15.4.0: Fri Feb 26 22:08:05 PST 2016; root:xnu-3248.40.184~3/RELEASE_X86_64 x86_64
```

As already expected we see our host OS is OS X or `Darwin` with a kernel version `15.4.0`. Our CPU architecture is `x86_64`, which indicates that we're running on an Intel-based
64-bit CPU.

Second, let's start a basic Linux container and here we're using a Debian standard distro
for now. This will take a few second because the Docker Engine has to fetch/download
the Docker image `debian` from the Docker Hub.

```
docker run --rm -ti debian
Unable to find image 'debian:latest' locally
latest: Pulling from library/debian
fdd5d7827f33: Pull complete
a3ed95caeb02: Pull complete
Digest: sha256:e7d38b3517548a1c71e41bffe9c8ae6d6d29546ce46bf62159837aad072c90aa
Status: Downloaded newer image for debian:latest
root@9473484ea965:/#
```

As you can see, we now do have an interactive bash prompt within a running Debian
Linux container.
```
root@9473484ea965:/# uname -a
Linux 9473484ea965 4.1.19 #1 SMP Sun Mar 20 22:13:39 UTC 2016 x86_64 GNU/Linux

root@9473484ea965:/# cat /etc/os-release
PRETTY_NAME="Debian GNU/Linux 8 (jessie)"
NAME="Debian GNU/Linux"
VERSION_ID="8"
VERSION="8 (jessie)"
ID=debian
HOME_URL="http://www.debian.org/"
SUPPORT_URL="http://www.debian.org/support"
BUG_REPORT_URL="https://bugs.debian.org/"
root@9473484ea965:/#
```

I'd like to start a really tiny Linux container next, which starts even
faster than Debian. Alpine Linux is meant to be super-small and it brings a lot
of advantages into the container world, too.

Starting an interactive Alpine container is pretty much the same as Debian, but we
have to use a Bourne shell instead of bash.
```
docker run --rm -ti alpine sh
Unable to find image 'alpine:latest' locally
latest: Pulling from library/alpine
4d06f2521e4f: Pull complete
Digest: sha256:7739b19a213f3a0aa8dacbd5898c8bd467e6eaf71074296a3d75824e76257396
Status: Downloaded newer image for alpine:latest
/ #
```

As you can see, this container is running on the same kernel version like before, but
uses a completely different Linux distribution.

```
/ # uname -a
Linux 411883bd07d3 4.1.19 #1 SMP Sun Mar 20 22:13:39 UTC 2016 x86_64 Linux

/ # cat /etc/os-release
NAME="Alpine Linux"
ID=alpine
VERSION_ID=3.3.1
PRETTY_NAME="Alpine Linux v3.3"
HOME_URL="http://alpinelinux.org"
BUG_REPORT_URL="http://bugs.alpinelinux.org"
/ #
```

Now, let's look at the details of these both Docker containers. Both are complete
Linux systems, but with a substantial difference in size.

```
docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
alpine              latest              70c557e50ed6        3 weeks ago         4.798 MB
debian              latest              f50f9524513f        3 weeks ago         125.1 MB
```

Alpine Linux is damn small in size and thus the Docker images built upon Alpine
are extremely small as well, and much faster to download. Another major advantage is the
security model of Alpine Linux, which reduces the attack surface dramatically and
provides faster and easier security updates as well.

This experiment with "Docker for Mac" clearly demonstrates that we can run Linux
commands inside Docker containers with a Linux OS and a recent kernel version 4.1.19. This is indeed different to our host operating system OS X.

That's pure Docker container magic: running a Linux container seamlessly on our
development machine, here on a MacBook Pro (Retina, 15-inch, Mid 2014).


## The Magic behind the scenes

As I've shown you in the screenshots above, our host operating system, where the Docker
Client is running, is `darwin/amd64` or OS X, but the Docker Engine runs on `linux/amd64`.

Maybe you're wondering how this even can be possible, right?  
The answer is quite easy, "Docker for Mac" is shipping it's own lightweight hypervisor
called [xhyve](http://www.xhyve.org/), which itself is a port of the BSD hypervisor
[bhyve](http://www.bhyve.org/) to OS X.

The engineers at Docker have greatly enhanced xhyve to enable an optimized usage
to efficiently run Docker containers on OS X. Inside of the xhyve hypervisor,
the Docker Engine is running in a tiny small Linux VM, which is based upon the
[Alpine Linux](http://www.alpinelinux.org) distribution. With this great combination
of outstanding technologies we as users get the feeling to run Docker containers
natively on our Mac.

Honestly, there are even more great technical details packed into the new "Docker for Mac"
release, but we'll keep them for a later more advanced technical blog post.


## There is another big ARM surprise

With the public announcement of "Docker for Mac", I received an [Easter Egg tweet](https://twitter.com/avsm/status/713010884596080640) from one
of the Docker engineers, Anil Madhavapeddy, that they've just included another cool
feature, which attracts me most. He promised I could even run the Docker images, which
I built for an IoT device like a Raspberry Pi on my Mac now!

No way, that sounds to good to be true. And mainly because the Raspberry Pi uses
an ARM CPU, which cannot be executed on an Intel-based Mac, right?

To test this, I'll select one of my most famous Docker containers:
the webserver I've presented at DockerCon 2015 San Francisco, CA, last year in June (more details can be found in a dedicated blog post about the [Hypriot-Demo and challenge at DockerCon 2015](/post/dockercon2015/)).

Ok, here we go. Let's run an ARM container on a Mac:

![Docker for Mac](/images/first-touch-down-with-docker-for-mac/docker4mac-arm-container-01.jpg)

As you can see, it doesn't work that way...  
...hmmm, but maybe with some more magic Docker spells it could be done.

![Docker for Mac](/images/first-touch-down-with-docker-for-mac/docker4mac-arm-container-02.jpg)

And this is where all the magic happens. We're just bind-mounting a special binary
into our original ARM-based container. Again, we don't change the original Docker
image to get this done. In the end we are really able to run an ARM container,
which was built on a Raspberry Pi, now on an Intel-based Mac - just with the help
of some [fantastic Docker fu](https://twitter.com/quintus23m/status/713523016836231171)
embedded in "Docker for Mac".

![Docker for Mac](/images/first-touch-down-with-docker-for-mac/docker4mac-arm-container-05.jpg)

As a last proof, we check with `docker ps` that we're running the original ARM container from June 2015:
![Docker for Mac](/images/first-touch-down-with-docker-for-mac/docker4mac-arm-container-04.jpg)

This is possible because the Docker engineers have already included the Linux kernel support
for `binfmt_misc` into "Docker for Mac". And as long as there is the right Qemu interpreter
`qemu-arm-static` (which is an Intel binary itself) placed in the ARM container,
this container can be executed, or better emulated, even on a foreign CPU architecture.

Now I can clearly imagine to use "Docker for Mac" as part of a new Docker-centric workflow
to build IoT containers directly on my Mac. Development and testing can be done fast and
efficiently on the developers machine and then deploying and running the IoT containers
on the target device. A few months ago such an idea has sound pretty crazy and unbelievable -
but now it's coming true soon.

Special thanks to Anil, Justin and all the other great guys at the Docker engineering
team to make this magic true.


## Key Takeaways

After this first and fast walk-through, I guess you're even more curious and you'd
like to use "Docker for Mac" by yourself. So in the meantime I'll just summarize the
key points what impressed me most about this great new release.

* installing "Docker for Mac" was pretty easy and slick
* a single `.dmg` media with 90 MByte only
* "Docker for Mac" is a real native OS X application
* there are absolutely no other external resources or dependencies to install
* "Docker for Mac" integrates perfectly into your development workflow
* downloading, installing and running the first Docker container takes a few minutes only
* for tiny containers, Alpine Linux is one of the best Linux distros
* ARM IoT containers can be developed and run even on a Mac
* ...much more will be revealed in later blog posts

Please send us your feedback on our [Gitter channel](https://gitter.im/hypriot/talk) or tweet your thoughts and ideas on this project at [@HypriotTweets](https://twitter.com/HypriotTweets).

Dieter [@Quintus23M](https://twitter.com/Quintus23M)
