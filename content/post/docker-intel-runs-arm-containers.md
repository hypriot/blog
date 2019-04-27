+++
date = "2019-04-27T10:48:50-07:00"
title = "Docker Engine on Intel Linux runs Arm Containers"
draft = false
more_link = "yes"
Tags = ["Docker","Container","Linux","Kernel","Arm"]
Categories = ["Docker","Container","Linux","Kernel","Arm"]

+++

Did you read the latest news from Docker about their newly announced technology partnership together with Arm, ["Docker and Arm Partner to Deliver Frictionless Cloud-Native Software Development and Delivery Model for Cloud, Edge, and IoT"](https://twitter.com/Docker/status/1121054608795688963)?

![arm-docker-logo.jpg](/images/docker-intel-runs-arm-containers/arm-docker-logo.jpg)

This is really a great ground-breaking news, as it will enable an improved development workflow. Build and test all your Arm containers on your Intel-based laptop or workstation. These new Arm capabilities will be available in [Docker Desktop](https://www.docker.com/products/docker-desktop) products from Docker, both for MacOs and Windows, and for Docker’s commercial enterprise offerings. First technical details and roadmap will be announced next week at [DockerCon 2019](https://www.docker.com/dockercon/) in San Francisco, so please stay tuned.

But wait, what about all the users who are directly working on a pure Linux environment? Well, here is the good news, the basic technology you need is already available and ready-to-use for you.

Yes, you could use it right away! Let's start it now...


<!--more-->

### Run an Arm Container with Docker Engine on Intel

I don't want to hold you back and bore you with a lot of background details, so I'm going to show you how easy it is today.

First, let's start with a default Docker Engine installed on an Intel-based Linux system. For the sake of simplicity I'd like to show it directly on the [Katacoda Training Platform](https://www.katacoda.com), then you are able to replay it without spending too much time. It just takes you a few seconds to spin up a complete Linux Docker environment, just a few click away. 


**Step 1:** Start the [Docker Tutorial](https://www.katacoda.com/contino/courses/docker/basics)

Next you have to click on "START SCENARIO" and the Linux Docker environment is ready for you.

![katacoda-docker-tutorial-start.jpg](/images/docker-intel-runs-arm-containers/katacoda-docker-tutorial-start.jpg)


**Step 2:** Run an Arm-based Container

In the bottom right box you'll find a Linux Terminal window where you can issue your CLI commands. It's a real Linux bash shell you can control through your browser and Docker is already installed on this machine.

As soon as we try to start an Arm-based Docker container,
```bash
$ docker run -it dieterreuter/alpine-arm64:3.9
```
we'll get an cryptic error message `exec user process caused "exec format error"`, which basically tells us that this Docker Image tries to start a binary/executable which can't be run on the provided Intel processor.

![katacoda-docker-tutorial-runarm1.jpg](/images/docker-intel-runs-arm-containers/katacoda-docker-tutorial-runarm1.jpg)


**Step 3:** Run the magic command to enable Arm/Arm64 on Intel

```bash
$ docker run --rm --privileged hypriot/qemu-register
```

This registers a few Qemu emulators inside of our Linux kernel with the help of the `binfmt` tool. This instructs the Linux loader to start the specific Qemu emulator program to run the binary/executable if it's not based on Intel. Here we register `/qemu-arm` for Arm 32-bit and `/qemu-aarch64` for Arm 64-bit.

Just to be precise, these emulators will be registered through a privileged Docker container. This is possible for all Linux kernel 4.9 and later. The emulators will be uploaded into memory, registered in the kernel and stay there persistent until you reboot your machine. This means you don't have to change anything inside of your Docker Images, all magic will be done by the Linux kernel on the host system!


```bash
$ docker run --rm --privileged hypriot/qemu-register
Unable to find image 'hypriot/qemu-register:latest' locally
latest: Pulling from hypriot/qemu-register
fc1a6b909f82: Pull complete
247c87d40120: Pull complete
1e300bd4bcdc: Pull complete
79c54222eda0: Pull complete
7d0efdace32f: Pull complete
Digest: sha256:17931ba1f5362c6fbf7f364b32bec7e06e0c376571a9e3b2849dea18ce887c91
Status: Downloaded newer image for hypriot/qemu-register:latest
---
Installed interpreter binaries:
-rwxr-xr-x    3 root     root       6192520 Apr 27 17:17 /qemu-aarch64
-rwxr-xr-x    4 root     root       5606984 Apr 27 17:17 /qemu-arm
-rwxr-xr-x    2 root     root       5987464 Apr 27 17:17 /qemu-ppc64le
---
Registered interpreter=qemu-aarch64
enabled
interpreter /qemu-aarch64
flags: OCF
offset 0
magic 7f454c460201010000000000000000000200b700
mask ffffffffffffff00fffffffffffffffffeffffff
---
Registered interpreter=qemu-arm
enabled
interpreter /qemu-arm
flags: OCF
offset 0
magic 7f454c4601010100000000000000000002002800
mask ffffffffffffff00fffffffffffffffffeffffff
---
Registered interpreter=qemu-ppc64le
enabled
interpreter /qemu-ppc64le
flags: OCF
offset 0
magic 7f454c4602010100000000000000000002001500
mask ffffffffffffff00fffffffffffffffffeffff00
---
$
```


**Step 4:** Run an Arm-based Container successfully on Intel

Now let's start the same Arm-based Docker container again, but this time it actually works successfully.
```bash
$ docker run -it dieterreuter/alpine-arm64:3.9
```

![katacoda-docker-tutorial-runarm2.jpg](/images/docker-intel-runs-arm-containers/katacoda-docker-tutorial-runarm2.jpg)

When we run the command `uname -a` it tell us, we're running a Linux kernel 4.14.29 on Arm 64-bit architecture indicated as `aarch64`.

SUCCESS, our Arm 64-bit Docker Container even works on Intel CPU's !!!

**References:** The source code of this magic registration Docker Image is fully open source and can be found at https://github.com/hypriot/qemu-register. I also updated it today to the latest available Qemu 4.0.0 release.


### Conclusion

As you could see, it's damn easy to configure your Intel-based Linux Docker Engine to run 32 or 64-bit Arm Containers in an emulation mode seemlessly. As long as you run a recent Linux kernel 4.9 or later it just works.

Basically this is the same emulation technology how [Docker Desktop](https://www.docker.com/products/docker-desktop) is doing this behind the scenes on MacOS and Windows. BTW, this binfmt feature is already built-in in Docker Desktop since about April 2017.

In the end it's possible for a user to develop, build and test his/her Arm-based Docker Containers easily on a Intel-based Linux machine. And with the upcoming new features built-in into the Docker Engine this multi-architecture development workflow will get better and better over time.

For Linux users we can use at least all these basic features. And for Mac and Windows users, Docker will present an even better user experience, so stay tuned for [DockerCon 2019](https://www.docker.com/dockercon/) in San Francisco next week.


### Feedback, please

As always use the comments below to give us feedback and share it on Twitter or Facebook.

Please send us your feedback on our [Gitter channel](https://gitter.im/hypriot/talk) or tweet your thoughts and ideas on this project at [@HypriotTweets](https://twitter.com/HypriotTweets).

Dieter [@Quintus23M](https://twitter.com/Quintus23M)
