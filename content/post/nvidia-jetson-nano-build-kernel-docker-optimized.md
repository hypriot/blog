+++
date = "2019-05-04T03:57:21+02:00"
title = "NVIDIA Jetson Nano - Docker optimized Linux Kernel"
draft = false
more_link = "yes"
Tags = ["Docker","Container","Linux","Kernel","Compatibility","Kubernetes","k8s","k3s","Networking","ipvlan"]
Categories = ["Docker","Container","Linux","Kernel","Compatibility","Kubernetes","k8s","k3s","Networking","ipvlan"]


+++

Despite the fact that the NVIDIA Jetson Nano DevKit comes with Docker Engine preinstalled and you can run containers just out-of-the-box on this great AI and Robotics enabled board, there are still some important kernel settings missing to run Docker Swarm mode, Kubernetes or k3s correctly. 

![jetson-nano-board-docker-whale.jpg](/images/nvidia-jetson-nano-build-kernel-docker-optimized/jetson-nano-board-docker-whale.jpg)

So, let's try to fix this...


<!--more-->

### Analyzing the Linux Kernel

In my last blogpost [Verify your Linux Kernel for Container Compatibility](https://blog.hypriot.com/post/verify-kernel-container-compatibility/), I already shared all the details how you can easily verify the Linux kernel for all Container related kernel settings. So, this first part of analyzing the capabilities of the stock Linux kernel 4.9.x provided by NVIDIA is already done and documented. And this was an easy task as well, so everyone who's interested in these details can repeat the task at his/her own device.

Let's recap what we did found. Especially there is one important setting which will be used for networking. This feature called "IPVLAN", is required for Docker Swarm mode and it's also used for networking in Kubernetes and k3s.


### Building your own Linux Kernel

Anyway, even when we'd like to include or change only a single kernel setting, we have to customize the kernel configuration and have to compile and build our own Linux kernel. This is typically a common task for a desktop Linux system, but can be pretty ugly and cumbersome if you have to build the kernel for an Embedded Device.

When we look back to all the other NVIDIA Jetson boards, like the TK1, TX1 and TX2, this requires a second Linux machine, running Ubuntu 14.04 or 16.04 on an Intel CPU. Then setting up a complete build system for cross-compiling and all these stuff. Honestly, this is a well-known approach for an Embedded Developer, but the good thing now for the Jetson Nano DevKit this is not required any more.

Here the good news: you can customize and build your own Linux kernel directly on the Jetson Nano DevKit! You only need an internet connection and some time to perform all steps on your own. BTW, and this is another chance to learn something new.


### Preparing the Build Environment

Before we're able to compile the Linux kernel on the Jetson Nano, we have to make sure we do have all required build tools installed. Here is all it takes, with a fast internet connection this is done within a few minutes only.

```bash
$ sudo apt-get update
$ sudo apt-get install -y libncurses5-dev
```


### Download Linux Kernel Sources for Jetson Nano

Next, we'll need to find and download the sources for the Linux kernel for the Jetson Nano DevKit directly from the NVIDIA website. The current version as writing this blogpost is NVIDIA Linux4Tegra Release r32.1 or short L4T 32.1. Just follow this link https://developer.nvidia.com/embedded/linux-tegra and select at topic "32.1 Driver Details" the referenced download link for "Jetson Nano", "SOURCES" and "BSP Sources".

We can also directly download this package to the Jetson Nano. But please be aware that this download link can change over time, so verify it carefully.
```bash
$ cd
$ mkdir -p nano-bsp-sources
$ cd nano-bsp-sources
$ wget https://developer.download.nvidia.com/embedded/L4T/r32_Release_v1.0/jetson-nano/BSP/Jetson-Nano-public_sources.tbz2
$ ls -alh Jetson-Nano-public_sources.tbz2
-rw-rw-r-- 1 pirate pirate 133M Mar 16 06:46 Jetson-Nano-public_sources.tbz2
```

Now extract the kernel source package "kernel_src.tbz2" from the downloaded file.
```bash
$ tar xvf Jetson-Nano-public_sources.tbz2 public_sources/kernel_src.tbz2
$ mv public_sources/kernel_src.tbz2 ~/
$ cd
$ ls -alh ~/kernel_src.tbz2
-rw-r--r-- 1 pirate pirate 117M Mar 13 08:45 /home/pirate/kernel_src.tbz2
```

You may now free some disk space and remove all the downloads, as we don't need it any more.
```bash
$ rm -fr ~/nano-bsp-sources/
```

Last step, please extract the kernel source tree.
```bash
$ cd
$ tar xvf ./kernel_src.tbz2
```


### Compile the default Linux Kernel

Cool, we have now all the Linux kernel source tree for the Jetson Nano DevKit downloaded and extracted.

As the next step, I'd recommend to first compile the default unmodified kernel in order to verify that we do have all the build dependencies installed and this way, we'll also get familiar with the kernel compiling. 

Before we can start the compile job, we have to make sure to use the correct kernel configuration file. This file ".config" is missing in the provided kernel source tree, but we can directly get it from our running Linux kernel on the Jetson Nano. This .config file can be found as kernel file at "/proc/config.gz" in a compressed form.
```bash
$ cd ~/kernel/kernel-4.9
$ zcat /proc/config.gz > .config
```

Now, let's verify the content of the Linux kernel .config file.
```bash
pirate@jetson-nano:~/kernel/kernel-4.9$ head -10 .config
#
# Automatically generated file; DO NOT EDIT.
# Linux/arm64 4.9.140 Kernel Configuration
#
CONFIG_ARM64=y
CONFIG_64BIT=y
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_MMU=y
CONFIG_DEBUG_RODATA=y
CONFIG_ARM64_PAGE_SHIFT=12
...
```

As you can see, it's a Kernel Configuration for Linux kernel version 4.9.140 and for ARM 64-bit architecture.

Start the kernel compile job. As we do have 4x cores available on the Nano, we'd like to keep the CPU busy and using 5x parallel compile tasks.
```bash
$ make prepare
$ make modules_prepare

# Use 5x parallel compile tasks
# Compile kernel as an image file
$ time make -j5 Image
...
real	28m13,235s
user	91m48,700s
sys	7m46,240s

# List newly compiled kernel image
$ ls -alh arch/arm64/boot/Image
-rw-rw-r-- 1 pirate pirate 33M May  4 00:14 arch/arm64/boot/Image

# Compile all kernel modules
$ time make -j5 modules
...
real	29m15,621s
user	92m41,176s
sys	8m18,404s
```

The Nano CPU's are pretty busy while compiling the kernel and kernel modules.

![jetson-nano-board-compile-kernel.jpg](/images/nvidia-jetson-nano-build-kernel-docker-optimized/jetson-nano-board-compile-kernel.jpg)

The build/compile job will take around 60 minutes in total, but the good thing is, all happens directly on your Jetson Nano DevKit. No other expensive equipment is required at all, just an internet connection and some of your time.


### Install our newly built Linux Kernel and Modules

After these pretty long compile jobs for generating our own Linux kernel and kernel modules, we are ready to install the kernel and verify if it's able to boot correctly. Therefore we should make a backup of the old kernel first, then install the new kernel and also install all newly built kernel modules.

Before we install the new kernel and boot the Jetson Nano, let's check the default Linux kernel version. Then we can compare it later to our own kernel.
```bash
pirate@jetson-nano:~$ uname -a
Linux jetson-nano 4.9.140-tegra #1 SMP PREEMPT Wed Mar 13 00:32:22 PDT 2019 aarch64 aarch64 aarch64 GNU/Linux
```

Here is also a ASCIINEMA recording of a `check-config.sh` verification done with the default kernel.
[![asciicast](https://asciinema.org/a/244237.svg)](https://asciinema.org/a/244237?t=0:44)

As we can see, we do have a Linux kernel version "4.9.140-tegra". This one was compiled at "Wed Mar 13 00:32:22 PDT 2019" and it's the default kernel provided by NVIDIA for the Jetson Nano. 

Now, install our new kernel and kernel modules.
```bash
# Backup the old kernel image file
$ sudo cp /boot/Image /boot/Image.original

# Install modules and kernel image
$ cd ~/kernel/kernel-4.9
$ sudo make modules_install
$ sudo cp arch/arm64/boot/Image /boot/Image

# Verify the kernel images
pirate@jetson-nano:~/kernel/kernel-4.9$ ls -alh /boot/Image*
-rw-r--r-- 1 root root 33M May  4 00:55 /boot/Image
-rw-r--r-- 1 root root 33M May  4 00:49 /boot/Image.original
```

Now, reboot the Nano and check the kernel again.
```bash
pirate@jetson-nano:~$ uname -a
Linux jetson-nano 4.9.140 #1 SMP PREEMPT Sat May 4 00:12:56 CEST 2019 aarch64 aarch64 aarch64 GNU/Linux
```

As you can see, our newly compiled kernel is working. The kernel version has changed to "4.9.140", note the missing trailing "-tegra" which indicates this build is a custom build. And the compile date/time has also changed to "Sat May 4 00:12:56 CEST 2019".

**Hint:** Please remember, every time you do change a kernel setting and compile a new kernel, you have to install the kernel image file AND the kernel modules.


### Customizing the Linux Kernel Configuration

When it comes to the point to modify or customize the Linux kernel configuration, then this can get pretty complicated when you don't know where to start. First of all, it's a very bad idea to edit the .config file directly with an editor. Please, NEVER DO THIS - seriously!

The correct way to customize the kernel .config file is, to use the right tooling. One tool which is already built-in and available even in your bash shell (works also via ssh), is the tool `menuconfig`. Therefore we already installed the build dependency "libncurses5-dev" at the beginning. 

I don't want to go into all details on how to use `menuconfig`, therefore here are the basic commands to start it and then I did recorded an ASCIINEMA to change the setting for "IPVLAN". I think then you'll should get a good idea how this works.

```bash
# Backup the kernel config
$ cd ~/kernel/kernel-4.9
$ cp .config kernel.config.original

$ make menuconfig
```

ASCIINEMA recording on how to include the "IPVLAN" kernel setting.
[![asciicast](https://asciinema.org/a/244246.svg)](https://asciinema.org/a/244246?t=1:15)

Finally let's re-compile the kernel and the kernel modules and install them, like we did before.
```bash
$ cd ~/kernel/kernel-4.9

# Prepare the kernel build
$ make prepare
$ make modules_prepare

# Compile kernel image and kernel modules
$ time make -j5 Image
$ time make -j5 modules

# Install modules and kernel image
$ sudo make modules_install
$ sudo cp arch/arm64/boot/Image /boot/Image
```

Reboot the Nano and check the kernel again.


### Fast Forward - Fully Container Optimized Kernel Configuration

As you have learned here in this tutorial, you're now able to apply more and more settings to your kernel configuration. But this will take some time for sure.

In order to save you a lot of time and efforts, I've already optimized the Linux kernel in all details. Here you can find a public [Gist at Github](https://gist.githubusercontent.com/DieterReuter/a7d07445c9d62b45d9151c22b446c59b/) with my resulting kernel .config. You can download it directly to your Nano and compile your own Linux kernel with this configuration.

```bash
# Download the fully container optimized kernel configuration file
$ cd ~/kernel/kernel-4.9
$ wget https://gist.githubusercontent.com/DieterReuter/a7d07445c9d62b45d9151c22b446c59b/raw/6decc91cc764ec0be8582186a34f60ea83fa89db/kernel.config.fully-container-optimized 
$ cp kernel.config.fully-container-optimized .config

# Prepare the kernel build
$ make prepare
$ make modules_prepare

# Compile kernel image and kernel modules
$ time make -j5 Image
$ time make -j5 modules

# Install modules and kernel image
$ sudo make modules_install
$ sudo cp arch/arm64/boot/Image /boot/Image
```

Now, reboot the Nano and check the kernel again.
```bash
pirate@jetson-nano:~$ uname -a
Linux jetson-nano 4.9.140 #2 SMP PREEMPT Sat May 4 02:17:23 CEST 2019 aarch64 aarch64 aarch64 GNU/Linux

pirate@jetson-nano:~$ ls -al /boot/Image*
-rw-r--r-- 1 root root 34381832 May  4 03:13 /boot/Image
-rw-r--r-- 1 root root 34048008 May  4 00:49 /boot/Image.original
```

ASCIINEMA recording of the final run of `check-config.sh` with the fully optimized kernel for running Containers on the Jetson Nano DevKit.
[![asciicast](https://asciinema.org/a/244250.svg)](https://asciinema.org/a/244250?t=1:13)

**Result: An almost perfect Linux kernel to run Containers on the NVIDIA Jetson Nano!**

![jetson-nano-board-docker-running2.jpg](/images/nvidia-jetson-nano-build-kernel-docker-optimized/jetson-nano-board-docker-running2.jpg)


### Conclusion

As you could learn with this short, but highly technical tutorial, you're able to compile your own customized Linux kernel directly on the Jetson Nano DevKit without the need of an additional and maybe expensiv development machine. All can be done within an hour or two, and you have now the ability to change kernel settings whenever you want to. Just customize the kernel .config file, compile a new kernel and kernel modules and install it on your Nano.

This way you're now able to optimize the kernel for all your needs. For running Containers on the Nano with the help of Docker, Kubernetes or k3s, you're now well prepared and know how to do this by yourself.

Once the Linux kernel is fully optimized with all important Container related kernel settings, you can run Docker Swarm mode, Kubernetes and k3s with all features on that great ARM board from NVIDIA.

Finally, May the 4th be with You!
![may-the-4th-be-with-you.jpg](/images/nvidia-jetson-nano-build-kernel-docker-optimized/may-the-4th-be-with-you.jpg)


### Feedback, please

As always use the comments below to give us feedback and share it on Twitter or Facebook.

Please send us your feedback on our [Gitter channel](https://gitter.im/hypriot/talk) or tweet your thoughts and ideas on this project at [@HypriotTweets](https://twitter.com/HypriotTweets).

Dieter [@Quintus23M](https://twitter.com/Quintus23M)
