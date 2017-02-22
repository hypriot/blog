+++
title = "Let's build the smallest possible Docker image"
draft = false
more_link = "yes"
Tags = ["Docker","Raspberry Pi","ARM","Container"]
Categories = ["Docker","Raspberry Pi","ARM","Container"]
date = "2017-02-22T09:18:35+01:00"

+++

Imagine what happens if we're starting to use Docker containers on IoT devices. On small and slow devices with limited system resources and connected via a damn slow network connection we do have to care differently on how to build and ship our apps. In these circumstances it pays off and it's absolutely essential to optimize our applications and the resulting Docker images for size.

SIZE DOES MATTER

![docker-image-minimal.png](/images/build-smallest-possible-docker-image/docker-image-minimal.png)

If we're doing it right we'll get a lot of benefits such as blasting fast download speed for updating to a new or more secured version. On wireless networks we are also reducing the costs for data transfers as well.

According to my [tweet](https://twitter.com/quintus23m/status/834132186211180544) I'd like to start a new Docker challenge:

**How small is the smallest Docker image we could build, which prints a "Hello Docker World!"?**


<!--more-->

### Background

Sometimes developing directly on an IoT device can be pretty hard or nearly impossible due to the lack of enough system resources. These resources can be the amount of memory, disk space or CPU capacity - or it can be just a limited network connectivity over a low-bandwith 64kbit/sec wireless network.

So, let's assume we do have a Raspberry Pi already deployed in the field and this IoT device has such a low-bandwidth network connection. We're preparing our developing system to run on a bare-metal cloud server and we are transfering our build artefacts as ready-to-run Docker images regularly with each and every new release in a DevOps driven manner. For this reason we'd like to speed up the deployment with minimized Docker image sizes.

Wait, I thought a Docker image can be pretty heavy with up to 1 GByte or even larger? Well, that could happen if we're packing a whole Operating System like Ubuntu or Debian into our Docker images. But as we're building an IoT application we should take care about that situation. A Docker image can instead be build with an app consisting of a statically linked binary and when we start it as a Docker container it will run a single Linux process only.


### Creating our App in ARM assembly

TL;DR all the source code and build instructions can be found in this public [GitHub repo](https://github.com/DieterReuter/dockerchallenge-smallest-image).

Here is my starting example of an assembly program which just prints a single static text string. It is written in ARM assembly language and should be compiled into a really small binary we can run on any ARMv7 device.
```
$ cat hello.S
.data
msg:
    .ascii      "Hello Docker World!\n"
len = . - msg

.text

.globl _start
_start:
    /* syscall write(int fd, const void *buf, size_t count) */
    mov     %r0, $1     /* fd -> stdout */
    ldr     %r1, =msg   /* buf -> msg */
    ldr     %r2, =len   /* count -> len(msg) */
    mov     %r7, $4     /* write is syscall #4 */
    swi     $0          /* invoke syscall */

    /* syscall exit(int status) */
    mov     %r0, $0     /* status -> 0 */
    mov     %r7, $1     /* exit is syscall #1 */
    swi     $0          /* invoke syscall */
```

Let's compile and link it as a static program
```
$ as -o hello.o hello.S
$ ld -s -o hello hello.o
```

Show details about the binary
```
$ file hello
hello: ELF 32-bit LSB executable, ARM, EABI5 version 1 (SYSV), statically linked, stripped
```

Now as we do have our app as a single binary program, we can build our smallest Docker image easily from scratch. This new Docker image consists only our binary and nothing else of other components at all. But you have to know this only works if the binary is statically linked and has all necessary tools baked in.
```
$ cat Dockerfile.armhf
FROM scratch
ADD hello /hello
CMD ["/hello"]
```

Building the Docker image
```
$ docker build -t dieterreuter/hello -f Dockerfile.armhf .
```


### Starting point

With all the details I've shown above in this blog post I finally built a first super-small Docker image with an indicated size of 452 Bytes only.
```
$ docker images
REPOSITORY                   TAG                 IMAGE ID            CREATED             SIZE
dieterreuter/hello           latest              b961df9c849e        27 hours ago        452 B
```

Starting this Docker container on a Raspberry Pi (or another ARMv7 machine) will print the requested text string.
```
$ docker run dieterreuter/hello
Hello Docker World!
```

Well, if you're working with [Docker-for-Mac](https://docs.docker.com/docker-for-mac/) or [Docker-for-Windows](https://docs.docker.com/docker-for-windows/) you should try to run this command, too. I guess you'll be surprised what happens on your Intel based system when you start this Docker container which is containing an ARM binary. But this is a topic for another future blog post.


### Challenge details

There are not many rules for this challenge, but let's give you some hints:

1. the Docker image should output the text "Hello Docker World!" on the console
2. we measure the size of the Docker image with `docker images` or `docker image ls`
3. feel free to use a CPU architecture of your choice: Intel, ARMv7, ARMv8/AARCH64, ...

Please publish your results on DockerHub, source codes on GitHub and tweet about it on Twitter with the hashtag #DockerChallenge. The goal of this challenge is to get familiar with the techniques to build minimal sized Docker images not only for IoT use cases, to understand the fact that a Docker container can be just a single process, and that this process can be really extremely small itself. On the way we'll learn to take care about all the necessary steps to reduce the size and how we can optimize our development workflow as well.

![docker-image-minimal2.png](/images/build-smallest-possible-docker-image/docker-image-minimal2.png)

So, let's start the journey...


### Feedback, please

As always use the comments below to give us feedback and share it on Twitter or Facebook.

Please send us your feedback on our [Gitter channel](https://gitter.im/hypriot/talk) or tweet your thoughts and ideas on this project at [@HypriotTweets](https://twitter.com/HypriotTweets).

Dieter [@Quintus23M](https://twitter.com/Quintus23M)
