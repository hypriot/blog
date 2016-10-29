+++
Categories = ["Docker", "SolidRun", "ClearFog Pro", "ARM", "Marvell", "Armada"]
Tags = ["Docker", "SolidRun", "ClearFog Pro", "ARM", "Marvell", "Armada"]
date = "2016-03-16T18:14:02+01:00"
draft = false
more_link = "yes"
title = "Let's run Docker on the ClearFog Pro router board"

+++

Here is the follow up of our blog post series about the new ARM-based router board
from SolidRun which is powered by a dual core Marvell ARMADA ARMv7 CPU. In case
you missed the intro a few days ago, we highly recommend reading the technical
specifications first to get an impression of this board.

* Part 1: [Introducing the new ClearFog Pro Router Board from SolidRun](https://blog.hypriot.com/post/introducing-the-clearfog-pro-router-board/)

This time we'll get our hands on this new board and try to install Linux with a
recent kernel version and hopefully we're able to install and run the Docker Engine
the first time on this powerful device.

So let's get started and for our second episode we connect the ClearFog Pro to a
MacBookPro and powering this thing up...

![ClearFog Pro Eth2 Cabled](/images/clearfog-pro-part2/clearfog-pro-eth2-cabled.jpg)

<!--more-->

### First contact

We can connect the ClearFog Pro to a MacBookPro with a standard USB cable, because
SolidRun added a FTDI chip on the board (Note: you'll need to install the appropriate
FTDI device drivers).
![ClearFog Pro Serial Console](/images/clearfog-pro-part2/clearfog-pro-serial-console.jpg)

The microUSB connector acts as a debugging console and gives us access to the
Linux console as well. As soon as we're powering the board, we can see the console
output of the boot loader. Here we don't have a microSD card inserted and the bootloader
stops it's boot sequence and we proved that we are successfully connected.
```
BootROM - 1.73

Booting from MMC
Card did not respond to voltage select!
Error initializing MMC - FFFFFFEF

Trying Uart
```


### Install Linux

Normally we would start building our own HypriotOS for a new board, in order to get a
perfect Linux kernel with tuned settings and a Debian-based Linux distro to run Docker
in an optimized way. But this time it turns out we are able to jump start pretty fast
and using Armbian for this first testing.

For this purpose we've created Armbian for the ClearFog Pro from source and getting a brand-new
Linux kernel 4.4.5 and all things packaged into a ready-to-install SD card image. Now, we
only have to flash the image to a microSD card with the [Hypriot flash tool](https://github.com/hypriot/flash)
and boot up the board.
```
flash Armbian_5.05_Armada_Debian_jessie_4.4.5.raw
```

On the login prompt we're using username `root` with the initial password `1234`
to login the first time.
```
Debian GNU/Linux 8 armada ttyS0

armada login:
```

Once we've changed the root password and created another user account, we do have
access to the console and can check the Armbian Linux system in detail.
```
root@armada:~# uname -a
Linux armada 4.4.5-marvell #2 SMP Wed Mar 16 09:42:31 UTC 2016 armv7l GNU/Linux
```

As you can see, this is indeed a current Linux kernel version 4.4.5. The very latest
Linux kernel release is 4.5 and it was just released a few days ago and we should expect
it will be supported soon for the ClearFog Pro board too.

Let's dive a little bit deeper and we can see our board is running with 1 GByte
of main memory.
```
root@armada:~# cat /proc/meminfo
MemTotal:        1027860 kB
MemFree:          910964 kB
MemAvailable:     973540 kB
Buffers:           11104 kB
Cached:            66864 kB
SwapCached:            0 kB
Active:            56388 kB
Inactive:          37856 kB
Active(anon):      17536 kB
Inactive(anon):     6540 kB
Active(file):      38852 kB
Inactive(file):    31316 kB
Unevictable:           0 kB
Mlocked:               0 kB
HighTotal:        262144 kB
HighFree:         237664 kB
LowTotal:         765716 kB
LowFree:          673300 kB
SwapTotal:        131068 kB
SwapFree:         131068 kB
Dirty:                 8 kB
Writeback:             0 kB
AnonPages:         16340 kB
Mapped:            10092 kB
Shmem:              7804 kB
Slab:              11668 kB
SReclaimable:       5004 kB
SUnreclaim:         6664 kB
KernelStack:         720 kB
PageTables:          360 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:      644996 kB
Committed_AS:      56040 kB
VmallocTotal:     245760 kB
VmallocUsed:           0 kB
VmallocChunk:          0 kB
```

And a dual core ARMv7 from a Marvell Armada 380 / 385 CPU. To be precise, it's a
Marvell ARMADA 388 CPU with up to 1.6GHz.
```
root@armada:~# cat /proc/cpuinfo
processor       : 0
model name      : ARMv7 Processor rev 1 (v7l)
BogoMIPS        : 50.00
Features        : half thumb fastmult vfp edsp thumbee neon vfpv3 tls vfpd32
CPU implementer : 0x41
CPU architecture: 7
CPU variant     : 0x4
CPU part        : 0xc09
CPU revision    : 1

processor       : 1
model name      : ARMv7 Processor rev 1 (v7l)
BogoMIPS        : 50.00
Features        : half thumb fastmult vfp edsp thumbee neon vfpv3 tls vfpd32
CPU implementer : 0x41
CPU architecture: 7
CPU variant     : 0x4
CPU part        : 0xc09
CPU revision    : 1

Hardware        : Marvell Armada 380/385 (Device Tree)
Revision        : 0000
Serial          : 0000000000000000
```

Here is a detailed picture of the SOM (System On Module), which includes the CPU
and the DDR3 memory chips.
![ClearFog Pro MicroSOM](/images/clearfog-pro-part2/clearfog-pro-microsom-a388-top-transparent.jpg)

Once we attach an ethernet cable to the ethernet connector next to the USB plug,
we should have the network interface `eth2` running. If there is no IP address
assigned we can use `dhclient eth2` to fetch a new TCP/IP address via DHCP.
```
root@armada:~# dhclient eth2
[  262.372335] mvneta f1070000.ethernet eth2: PHY [f1072004.mdio-mi:00] driver [Marvell 88E1510]
[  262.380889] mvneta f1070000.ethernet eth2: configuring for link AN mode phy
[  262.387949] IPv6: ADDRCONF(NETDEV_UP): eth2: link is not ready
[  265.371548] mvneta f1070000.ethernet eth2: Link is Up - 100Mbps/Full - flow control rx/tx
[  265.379757] IPv6: ADDRCONF(NETDEV_CHANGE): eth2: link becomes ready
```
```
root@armada:~# ifconfig eth2
eth2      Link encap:Ethernet  HWaddr 00:50:43:25:fb:84
          inet addr:192.168.2.108  Bcast:192.168.2.255  Mask:255.255.255.0
          inet6 addr: fe80::250:43ff:fe25:fb84/64 Scope:Link
          inet6 addr: 2003:86:8c11:a703:250:43ff:fe25:fb84/64 Scope:Global
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:57 errors:0 dropped:0 overruns:0 frame:0
          TX packets:44 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:532
          RX bytes:7746 (7.5 KiB)  TX bytes:4300 (4.1 KiB)
          Interrupt:41
```

Finally let's check if we have an internet connection to proceed with our installation.
```
root@armada:~# ping -c 3 google.com
PING google.com (173.194.116.206) 56(84) bytes of data.
64 bytes from fra07s64-in-f14.1e100.net (173.194.116.206): icmp_seq=1 ttl=57 time=27.0 ms
64 bytes from fra07s64-in-f14.1e100.net (173.194.116.206): icmp_seq=2 ttl=57 time=26.8 ms

--- google.com ping statistics ---
3 packets transmitted, 2 received, 33% packet loss, time 2003ms
rtt min/avg/max/mdev = 26.828/26.959/27.091/0.210 ms
```

Ok, that's great. We do have now a Debian Jessie Linux distro called `Armbian`
with a most recent Linux kernel 4.4.5 running on the ClearFog Pro.


### Installing the Docker Engine

Before we try to install Docker, we'd like to know about if the Linux kernel settings
are sufficient to run Docker in a decent way. Remember, most of the standard Linux
kernels for dev boards lacks the support for a few important kernel options, and this
could cause major problems to run Docker.

But let's have a look here and check the kernel settings with a check script which
is thankfully provided by the Docker core team.
```
wget https://github.com/docker/docker/raw/master/contrib/check-config.sh
chmod +x check-config.sh
```
```
./check-config.sh
info: reading kernel config from /proc/config.gz ...

Generally Necessary:
- cgroup hierarchy: properly mounted [/sys/fs/cgroup]
- CONFIG_NAMESPACES: enabled
- CONFIG_NET_NS: enabled
- CONFIG_PID_NS: enabled
- CONFIG_IPC_NS: enabled
- CONFIG_UTS_NS: enabled
- CONFIG_DEVPTS_MULTIPLE_INSTANCES: missing
- CONFIG_CGROUPS: enabled
- CONFIG_CGROUP_CPUACCT: enabled
- CONFIG_CGROUP_DEVICE: enabled
- CONFIG_CGROUP_FREEZER: enabled
- CONFIG_CGROUP_SCHED: enabled
- CONFIG_CPUSETS: enabled
- CONFIG_MEMCG: enabled
- CONFIG_KEYS: enabled
- CONFIG_MACVLAN: enabled
- CONFIG_VETH: enabled
- CONFIG_BRIDGE: enabled
- CONFIG_BRIDGE_NETFILTER: enabled (as module)
- CONFIG_NF_NAT_IPV4: enabled (as module)
- CONFIG_IP_NF_FILTER: enabled (as module)
- CONFIG_IP_NF_TARGET_MASQUERADE: enabled (as module)
- CONFIG_NETFILTER_XT_MATCH_ADDRTYPE: enabled (as module)
- CONFIG_NETFILTER_XT_MATCH_CONNTRACK: enabled (as module)
- CONFIG_NF_NAT: enabled (as module)
- CONFIG_NF_NAT_NEEDED: enabled
- CONFIG_POSIX_MQUEUE: enabled

Optional Features:
- CONFIG_USER_NS: missing
- CONFIG_SECCOMP: missing
- CONFIG_CGROUP_PIDS: missing
- CONFIG_MEMCG_KMEM: enabled
- CONFIG_MEMCG_SWAP: enabled
- CONFIG_MEMCG_SWAP_ENABLED: enabled
- CONFIG_BLK_CGROUP: enabled
- CONFIG_IOSCHED_CFQ: enabled
- CONFIG_BLK_DEV_THROTTLING: enabled
- CONFIG_CGROUP_PERF: enabled
- CONFIG_CGROUP_HUGETLB: missing
- CONFIG_NET_CLS_CGROUP: missing
- CONFIG_CGROUP_NET_PRIO: missing
- CONFIG_CFS_BANDWIDTH: enabled
- CONFIG_FAIR_GROUP_SCHED: enabled
- CONFIG_RT_GROUP_SCHED: enabled
- CONFIG_EXT3_FS: missing
- CONFIG_EXT3_FS_XATTR: missing
- CONFIG_EXT3_FS_POSIX_ACL: missing
- CONFIG_EXT3_FS_SECURITY: missing
    (enable these ext3 configs if you are using ext3 as backing filesystem)
- CONFIG_EXT4_FS: enabled
- CONFIG_EXT4_FS_POSIX_ACL: enabled
- CONFIG_EXT4_FS_SECURITY: enabled
- Storage Drivers:
  - "aufs":
    - CONFIG_AUFS_FS: missing
  - "btrfs":
    - CONFIG_BTRFS_FS: enabled
  - "devicemapper":
    - CONFIG_BLK_DEV_DM: missing
    - CONFIG_DM_THIN_PROVISIONING: missing
  - "overlay":
    - CONFIG_OVERLAY_FS: enabled (as module)
  - "zfs":
    - /dev/zfs: missing
    - zfs command: missing
    - zpool command: missing
```

This report tells us that the kernel 4.4.5 provided by Armbian is quite well,
but it's not perfectly optimized for Docker usage. Anyway, we'll give it a try
and will see how far we can go before we're trying to optimize the kernel settings
even further.

As this board has a standard ARMv7 CPU we can easily install the Docker Engine from
the Hypriot package repository. BTW, that's exactly the same version we're running
on all the Raspberry Pi's, ODROID's and other ARMv6 or ARMv7 boards as well.
```
apt-get install -y apt-transport-https
wget -q https://packagecloud.io/gpg.key -O - | apt-key add -
echo 'deb https://packagecloud.io/Hypriot/Schatzkiste/debian/ wheezy main' >> /etc/apt/sources.list.d/hypriot.list
apt-get update
apt-get install -y docker-hypriot
```

Finally, let's check the Docker version and infos and see if all is installed the
right way.
```
docker version
Client:
 Version:      1.10.3
 API version:  1.22
 Go version:   go1.4.3
 Git commit:   20f81dd
 Built:        Thu Mar 10 22:23:48 2016
 OS/Arch:      linux/arm

Server:
 Version:      1.10.3
 API version:  1.22
 Go version:   go1.4.3
 Git commit:   20f81dd
 Built:        Thu Mar 10 22:23:48 2016
 OS/Arch:      linux/arm
```
```
docker info
Containers: 0
 Running: 0
 Paused: 0
 Stopped: 0
Images: 0
Server Version: 1.10.3
Storage Driver: overlay
 Backing Filesystem: extfs
Execution Driver: native-0.2
Logging Driver: json-file
Plugins:
 Volume: local
 Network: host bridge null
Kernel Version: 4.4.5-marvell
Operating System: Debian GNU/Linux 8 (jessie)
OSType: linux
Architecture: armv7l
CPUs: 2
Total Memory: 1004 MiB
Name: armada
ID: CH4K:7X5P:SF47:C6NN:CRIF:OIUS:66TM:PJFL:D5ET:APW2:KCKT:DWBT
Debug mode (server): true
 File Descriptors: 12
 Goroutines: 20
 System Time: 2016-03-16T16:34:52.01930928Z
 EventsListeners: 0
 Init SHA1: 0db326fc09273474242804e87e11e1d9930fb95b
 Init Path: /usr/lib/docker/dockerinit
 Docker Root Dir: /var/lib/docker
WARNING: No memory limit support
WARNING: No swap limit support
WARNING: No oom kill disable support
```

Perfect! As you can see, we do have now the latest Docker Engine release v1.10.3 up and running
on the ClearFog Pro. And it's using Overlay filesystem which is really great. But
there are also some warnings displayed - this will be fixed later with our own
Linux distro HypriotOS.

Checking the status of the `docker service` reveals, that the service is running
but it's not enabled yet.
```
systemctl status docker
● docker.service - Docker Application Container Engine
   Loaded: loaded (/lib/systemd/system/docker.service; disabled)
   Active: active (running) since Wed 2016-03-16 16:34:27 UTC; 49s ago
     Docs: https://docs.docker.com
 Main PID: 4219 (docker)
   CGroup: /system.slice/docker.service
           └─4219 /usr/bin/docker daemon -H fd:// --storage-driver=overlay -D...
```

Thus we should enable it to get the Docker Engine automatically started on the next
reboot of the board.
```
systemctl enable docker
Synchronizing state for docker.service with sysvinit using update-rc.d...
Executing /usr/sbin/update-rc.d docker defaults
Executing /usr/sbin/update-rc.d docker enable
```

Wow, this was really damn easy. Nothing complicated and nothing special until now.
It seems that with Armbian the Docker Engine 1.10.3 is just running almost out-of-the-box.


### Running the first Docker container

Now, we'd like to start a first Docker container and we're just using a very small
web server.
```
docker run -d -p 80:80 hypriot/rpi-busybox-httpd
Unable to find image 'hypriot/rpi-busybox-httpd:latest' locally
latest: Pulling from hypriot/rpi-busybox-httpd
c74a9c6a645f: Pull complete
6f1938f6d8ae: Pull complete
e1347d4747a6: Pull complete
a3ed95caeb02: Pull complete
Digest: sha256:c00342f952d97628bf5dda457d3b409c37df687c859df82b9424f61264f54cd1
Status: Downloaded newer image for hypriot/rpi-busybox-httpd:latest
c6bf2a8a534dea6b5afd2cf466ed1828bae2f77ba06e7563732e3b416c607d6b
[  705.631098] device vethe5d37f3 entered promiscuous mode
[  705.636762] IPv6: ADDRCONF(NETDEV_UP): vethe5d37f3: link is not ready
[  706.011850] eth0: renamed from veth4dd291a
[  706.052008] IPv6: ADDRCONF(NETDEV_CHANGE): vethe5d37f3: link becomes ready
[  706.058946] docker0: port 1(vethe5d37f3) entered forwarding state
[  706.065096] docker0: port 1(vethe5d37f3) entered forwarding state
[  706.071820] IPv6: ADDRCONF(NETDEV_CHANGE): docker0: link becomes ready
[  706.095771] devpts: called with bogus options
```

Ok, the web server seems to be running fine.
```
docker ps -a
CONTAINER ID        IMAGE                       COMMAND                  CREATED             STATUS              PORTS                NAMES
c6bf2a8a534d        hypriot/rpi-busybox-httpd   "/bin/busybox httpd -"   21 seconds ago      Up 19 seconds       0.0.0.0:80->80/tcp   sharp_hugle
```

We can check the web server via a simple `curl` command on the ClearFog console or
from the MacBookPro.
```
curl 192.168.2.108
<html>
<head><title>Pi armed with Docker by Hypriot</title>
  <body style="width: 100%; background-color: black;">
    <div id="main" style="margin: 100px auto 0 auto; width: 800px;">
      <img src="pi_armed_with_docker.jpg" alt="pi armed with docker" style="width: 800px">
    </div>
  </body>
```

Or, we just point our web browser with `open http://192.168.2.108/` to the main web page.
![ClearFog Pro WebBrowser](/images/clearfog-pro-part2/clearfog-pro-webbrowser.jpg)


### Current status and key takeaways

The web site of SolidRun says, they're supporting a Linux kernel 3.x only and this would
be way too old and outdated. But luckily we figured out there is already support for
the very latest Linux kernel 4.x versions available. SolidRun has an own kernel repo
on GitHub where you can find all the changes and patches, these patches are already
included by Armbian as well.

We just double-checked this directly with SolidRun and they told us, they're already
working on it, to get all the Marvell related kernel patches for the ClearFog Pro
into the mainline Linux kernel. They plan to get everything merged into LK 4.6. This could
maybe mean that not all the special features of the board will be supported right now
with a kernel 4.x, but we'll test this later on.

This engagement of SolidRun sounds pretty fantastic and we highly encourage them to proceed
with this strategy. With supporting the latest mainline Linux kernel with hopefully
all hardware features this could become one of the best router boards on the market.
It's powerful with high-speed networking and supports Docker container technology too.


### Next steps

The Linux kernel and SD image provided by Armbian looks really good at this point
and can be used for the first steps with Docker. But we think there is almost a
lot of room for improvements which we'd like to pick up and optimize the kernel
settings. As soon as this ground work is done, we'll create a SD card image with
HypriotOS for the ClearFog Pro router board and release this soon.

But this will be covered in the next detailed posts of this series, so please
stay tuned...


Please send us your feedback on our [Gitter channel](https://gitter.im/hypriot/talk) or tweet your thoughts and ideas on this project at [@HypriotTweets](https://twitter.com/HypriotTweets).

Dieter [@Quintus23M](https://twitter.com/Quintus23M)
