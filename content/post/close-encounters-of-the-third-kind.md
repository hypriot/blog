+++
Categories = ["Docker", "Docker for Windows", "Microsoft", "Windows", "Raspberry Pi", "ARM", "Hyper-V"]
Tags = ["Docker", "Docker for Windows", "Microsoft", "Windows", "Raspberry Pi", "ARM", "Hyper-V"]
date = "2016-03-29T17:20:34+02:00"
draft = false
more_link = "yes"
title = "Close Encounters of the Third Kind, or Microsoft Windows meets Docker ARM Containers for IoT"

+++

Running an ARM-based Docker container for IoT applications directly on Microsoft Windows
looks like an unbelievable **extraterrestrial technology** from outer space.

This cannot be true, it must be a fake, right?  
Or, is this maybe just a **cheap magic trick**?

![Docker for Windows](/images/close-encounters-of-the-third-kind/docker4win-arm-webpage.jpg)

Nope, believe me, that's really true...

<!--more-->

## Behind the scenes

As I showed in my last blog post about the [First Touch Down with Docker for Mac](http://blog.hypriot.com/post/first-touch-down-with-docker-for-mac/),
"Docker for Mac" uses an Alpine Linux VM under the hood with the capability of emulating
ARM binaries on Intel CPUs. Because of "Docker for Windows" uses exactly the same
Alpine Linux in a Hyper-V virtual machine, this should work on Windows 10, too.

The only problem here is, that the bind-mounting of a single binary doesn't work
right now on Windows. I guess this will be fixed in a later release for sure. But
we can easily prepare an ARM-based Docker container to make the magic happen.

We just have to put the [QEMU](https://en.wikipedia.org/wiki/QEMU) emulator binary
into the Docker container, and as long as we
place it at the correct path `/usr/bin/qemu-arm-static`, this should work. The easiest
way to include the binary to the correct folder is to create a tar archive and use
the ADD command in the Dockerfile.

```
tar vtf qemu-arm-static.tar
drwxr-xr-x  0 dieter staff       0 Mar 28 18:34 usr/
drwxr-xr-x  0 dieter staff       0 Mar 28 18:34 usr/bin/
-rwxr-xr-x  0 dieter staff 2899840 Mar 28 18:34 usr/bin/qemu-arm-static
```

#### Dockerfile
```
FROM hypriot/rpi-busybox-httpd
ADD qemu-arm-static.tar /
```

With this easy preparation we're able to start an ARM-based Docker container on
Windows 10 with two steps only.

**Step 1:** Create the modified Docker image
```
docker build -t rpi-busybox-httpd .
```

**Step 2:** Start the QEMU-enabled Docker container
```
docker run -d -p 80:80 rpi-busybox-httpd
```

Here in this screenshot you can see all the necessary steps we need, there is really
nothing else to do.

![Docker for Windows](/images/close-encounters-of-the-third-kind/docker4win-arm-container.jpg)

**Voilà** - that was the magic trick which can be applied to almost all ARM-based Docker
images to make them run in "Docker for Windows" and "Docker for Mac" even on an Intel-based
CPU architecture.


## Watch the results

"Docker for Windows" publishes the Docker Engine network with the local network name
`docker`. Thus to access the ARM web server, which is running inside of a Linux container,
 we just have to point our preferred web browser to `http://docker/`.

![Docker for Windows](/images/close-encounters-of-the-third-kind/docker4win-arm-webpage2.jpg)


## Key Takeaways

* "Docker for Windows" uses Windows native hypervisor Hyper-V
* the Docker Engine is running in a tiny Alpine Linux VM
* ARM-based Docker containers can be easily enabled with QEMU emulator
* Docker works great on Windows 10

Are you curious now and want to get in touch with "Docker for Windows" by yourself?
Then you should register for the Docker BETA program at https://beta.docker.com.


Please send us your feedback on our [Gitter channel](https://gitter.im/hypriot/talk) or tweet your thoughts and ideas on this project at [@HypriotTweets](https://twitter.com/HypriotTweets).

Dieter [@Quintus23M](https://twitter.com/Quintus23M)
