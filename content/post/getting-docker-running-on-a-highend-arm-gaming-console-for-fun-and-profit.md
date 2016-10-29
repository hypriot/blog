+++
Categories = ["Nvidia", "ShieldTV", "Docker", "Hypriot", "ARM", "ARM64", "ARMv8"]
Tags = ["Nvidia", "ShieldTV", "Docker", "Hypriot", "ARM", "ARM64", "ARMv8"]
date = "2015-12-28T09:00:00+01:00"
more_link = "yes"
title = "Getting Docker running on a high-end 64-bit ARM gaming console for fun and profit"

+++

I don't really know how this happened. Again. :(  
Somehow over and over again these little ARM devices and maker devboards end up on my desk.

So what is it this time?

Well, look at this beauty because words cannot even begin to describe it:

![](/images/nvidia-shieldtv/docker-on-nvidia-shieldtv.jpg)

Alright, start breathing again.

It is called the [Nvidia ShieldTV](http://shield.nvidia.com) and it's meant to be a media center.
Besides, it is one of the first Android gaming consoles that actually is worthy of the name.

It would be a really great Christmas present for my son. But that is purely hypothetical and he is totally out of luck here.

Why? Well, because the Nvidia Tegra X1 CPU is one of the first __64-bit ARM CPU's__ that can be bought __now__ and it is even __affordable__ with a price tag well under 200 bucks.

Being both Dieter and part of the Hypriot crew it should be clear now where this is heading, right?
As you all know Docker pirates love to be ARMed with little explosive stuff - and it doesn't get more explosive than the Nvidia ShieldTV.

So my son won't get to play any games soon because __I need__ to get Docker running on this little beauty.
A device engineered for performance and made to game. So, let's start playing...

<!--more-->

### How it all started

This spring, I was really happy to see Jen-Hsun Huang, CEO of Nvidia Corp. announcing a great new [gaming console](https://www.youtube.com/watch?v=1q30y_pfz5Q) - the [Nvidia ShieldTV](http://shield.nvidia.com/android-tv).
It's basically a 4K AndroidTV gaming machine and SmartTV device for the living room that easily connects to your big TV screen.

This device has some remarkable features and performance specs. The hardware is based upon the new [Nvidia Tegra X1](http://www.nvidia.com/object/tegra-x1-processor.html) chip with an incredible CPU/GPU power of more than 1 TeraFLOPs of performance. This is an ARMv8 (64-bit) processor with eight cores in a big-little configuration (4x A57 1.9GHz + 4x A53) and 3 Gbyte of memory.
For fast and efficient graphics, Nvidia has included 256 Maxwell GPU cores as well.

Looking at the Tegra X1 chip, it's dominated by the 256x CUDA GPU cores. Can you find the CPU cores? They are pretty hard to find. ;-)

![](/images/nvidia-shieldtv/nvidia-tegra-x1-chip.jpg)

All in all, this device has a lot of CPU power and an incredible amount of GPU power as well - especially for a low-cost device [at just $199.99](http://www.amazon.com/NVIDIA-SHIELD-Remote/dp/B013HJ13V0/ref=sr_1_3?ie=UTF8&qid=1451218402&sr=8-3&keywords=nvidia+shield).
It is easy to imagine that the ShieldTV could be used for so much more than just simple media streaming and gaming.

But how?

### In the beginning there was ...

__... Android__. Yeah, that is the strange operating system from Google that comes preinstalled with the Nvidia ShieldTV.

Android is OK for running the ShieldTV as a media center or gaming console, but for using it as general purpose desktop computer, another operating system would be much more convenient.
Linux for instance - if we were only able to hack the ShieldTV and install a Linux system on it, we would open it up for a much broader range of use cases.

Alright, I would be content with Docker for a start.

It turned out that this is everything but easy.

### Then there was ...

__... Ubuntu__. A few weeks ago I was able to install a basic Ubuntu 14.04 provided by Nvidia for their development boards.
This so called [Nvidia Linux For Tegra (L4T)](https://developer.nvidia.com/embedded/linux-tegra) is running a 64-bit kernel, but does only provide a 32-bit root file system.
Nvidia really? What a bummer. Hopefully they will change this in the future.

![](/images/nvidia-shieldtv/nvidia-shieldtv-running-ubuntu.jpg)

Later on, I created a Debian Jessie root file system directly from upstream, which is compiled for the ARM64 architecture.
Combining the standard Nvidia 64-bit kernel and a Debian Jessie root file system, I am able to boot the ShieldTV into a pure 64-bit Linux system - HELL YEAH, that's it!

Building the basic root file system was easy, but fixing all the network issues and Systemd settings was a real challenge.
Fortunately I got a lot of help from Andreas (another member of our Hypriot crew), who managed to fix them all.

### And after some more hard work there was ...
__... HypriotOS__. As a result the ShieldTV is now booting into a pure 64-bit environment in less than ten seconds.

![](/images/nvidia-shieldtv/nvidia-shieldtv-running-hypriotos-arm64.jpg)

As you can see the Nvidia ShieldTV is running our new 64-bit HypriotOS system on four CPU cores and has almost three gigabyte of memory available.

![](/images/nvidia-shieldtv/nvidia-shieldtv-running-hypriotos-htop.jpg)

### In the end there was ...
__... Docker__. This is the final piece that I wanted to get running. A first step in this direction is to get __Go 1.5.1__ and its build dependencies compiled.
After that it was a walk in the park to get the latest __Docker v1.10.0-dev__ compiled.

The only annoying thing that remains right now is that we still have an old 3.10.61 kernel that is not optimized for running Docker.

### Damn it! The last 20% are always the toughest...

The last few days I tried to build a custom Linux kernel for the ShieldTV that has all the right kernel settings for Docker enabled.
But I had no luck at all.

I was able to cross-compile a lot of different generic kernels for ARM64, but none of them were able to boot successfully on the ShieldTV.
And as you can imagine, debugging some kernel and boot issues without having a serial or UART console to get early boot messages, one is easily lost.

Enabling different kernel settings, building the kernel, flashing it and then trying to boot it was a really difficult and time consuming process.
Yesterday I was finally lucky enough to get almost all of the important kernel settings for Docker working im my custom 3.10.61 Linux kernel.
Honestly, this is quite an old kernel version and far from being perfect for Docker but it works for now and the Docker Engine is running the first time on this great device!

![](/images/nvidia-shieldtv/nvidia-shieldtv-running-docker-1.jpg)

So let's spin up a Docker image or two! Funny enough even a Docker image that was built for the Raspberry Pi can run on ARM64.
Who can remember it? This is exactly the same web server container I was demoing live on stage at [DockerCon 2015 in San Francisco](https://blog.hypriot.com/post/dockercon2015/).

![](/images/nvidia-shieldtv/nvidia-shieldtv-running-docker-3.jpg)

Maybe it is more interesting to run a real ARM64 Docker image to proof that our ARM 64-bit Docker engine is working just fine.
So here we go...

![](/images/nvidia-shieldtv/nvidia-shieldtv-running-docker-4.jpg)

That is already pretty impressive, but there is still a lot to do.

In the spirit of HypriotOS we want to deliver an easy out-of-the-box experience with the latest and greatest of software components.
This means we need a really easy way to flash and install HypriotOS on the ShieldTV similar to how we do it for the Raspberry Pi.
And all the included components should be really up-to-date: the Linux kernel (4.x) and of course all of the Docker tools as well.

![](/images/nvidia-shieldtv/nvidia-shieldtv-on-my-desktop.jpg)

Maybe there are some of you who - after reading this article - want to get started hacking on the ShieldTV, too.
We really would appreciate getting some help here to move faster.
That's why we will publish the technical details in the coming weeks, so you can have a look and start hacking yourself.

Please send us your feedback on our [Gitter channel](https://gitter.im/hypriot/talk) or tweet your thoughts and ideas on this project at [@HypriotTweets](https://twitter.com/HypriotTweets).

Dieter [@Quintus23M](https://twitter.com/Quintus23M) & Andreas [@firecyberice](https://twitter.com/firecyberice)
