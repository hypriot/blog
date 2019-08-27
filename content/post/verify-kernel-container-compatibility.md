+++
date = "2019-04-28T08:48:50-07:00"
title = "Verify your Linux Kernel for Container Compatibility"
draft = false
more_link = "yes"
Tags = ["Docker","Container","Linux","Kernel","Compatibility"]
Categories = ["Docker","Container","Linux","Kernel","Compatibility"]


+++

Are you sure whether your Linux kernel is able to run Containers in an optimal way, or if there are still some missing kernel settings which will lead to some strange issues in the future?

![400px-NewTux.svg.png](/images/verify-kernel-container-compatibility/400px-NewTux.svg.png)

Normally you don't have to bother about this question. When you're using Docker and Containers on a modern Linux system or on a public cloud offering, this has been already optimized by the Linux distribution or your cloud provider. But when you start using Containers on Embedded Devices you should verify this carefully.

So, let's learn how easy it is to verify it by yourself...


<!--more-->

### How can I verify the Linux Kernel for Container Compatibility?

Typically this is really an easy task, as soon as you know the right tools.

For running Containers you'll need some basic settings applied to your Linux kernel. Some settings are mandatory and some others are optional and only used for specific use cases. But let's see how we can use the right tools.

At the Docker open source project you can find a great bash script which does all these tests on your Linux kernel configuration and tells you within a few seconds all the required details. The script is able to read the kernel config live from a running kernel or directly from a kernel .config file as well. Now you can imagine you can verify the container compatibility also from a remote device.


#### Download `check-config.sh` script

Let's download the bash script [check-config.sh](https://github.com/moby/moby/blob/master/contrib/check-config.sh) directly from the Moby project (yes, this is the new name for the Docker open source project).
```bash
$ wget https://github.com/moby/moby/raw/master/contrib/check-config.sh
$ chmod +x check-config.sh
```


#### Verify the Linux Kernel directly

If you have your Linux system available you can download and run the script directly without any parameters.
```bash
$ ./check-config.sh
```

Then you'll get a detailled output with all kernel settings which are important for running containers.

If you want to verify a kernel from a remote system, you could also first extract the Linux kernel config on this system and analyse it later.
```bash
# extract the .config from a running kernel
$ zcat /proc/config.gz > kernel.config

$ ls -al kernel.config
-rw-rw-r-- 1 pirate pirate 165739 Apr 28 07:26 kernel.config
```

**Hint:** On some Linux systems like Raspbian for the Raspberry Pi, the kernel .config is only available as a kernel module. Then you have to load the module first, using the command `sudo modprobe configs`.


#### Verify the Linux Kernel from a .config file

The kernel .config is a readable configuration file which is used to compile a new Linux kernel. Typically it will get embedded into your new kernel and therefore you can read it from the running kernel. It's available as a file at `/proc/config.gz` in a compressed form, so we have to use `zcat` to extract the .config file in clear text.
```bash
$ zcat /proc/config.gz | head -10
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

Next, let's run the `check-config.sh` script again and read all kernel configs from the file.
```bash
$ ./check-config.sh kernel.config
```


### Verify the Linux Kernel on NVIDIA Jetson Nano DevKit

As a real life example let's now verify the Linux kernel of the brand-new Jetson Nano DevKit from NVIDIA. I already wrote a blogpost about how to install Linux for the Nano board, see here [NVIDIA Jetson Nano Developer Kit - Introduction](https://blog.hypriot.com/post/nvidia-jetson-nano-intro/).

First we'll check the Linux kernel version and we can see, it's a current LTS kernel 4.9.
```bash
pirate@jetson-nano:~$ uname -a
Linux jetson-nano 4.9.140-tegra #1 SMP PREEMPT Wed Mar 13 00:32:22 PDT 2019 aarch64 aarch64 aarch64 GNU/Linux
```

Now, let's run the `check-config.sh` script on the Nano and determine all the Container related kernel settings. We'll get the complete output as colored text. From the screenshots here we can clearly see which of the required and optional kernel settings are already applied for the Nano's Linux kernel.

In the first section "Generally Necessary" all the mandatory kernel settings are listed, and for the Nano this is completely green, all is perfect.

![kernel-checkconfig-nano1.jpg](/images/verify-kernel-container-compatibility/kernel-checkconfig-nano1.jpg)

Then in the second section "Optional Features" we can see that most Container related settings are applied, but a few are missing.

Not all of these are really important to have, but when we look into the "Network Drivers" I would recommend to include all in the kernel to avoid issues. For example, if you want to use Docker Swarm mode you have to know that `CONFIG_IPVLAN` is mandatory - this kernel can't run Swarm mode correctly!

For "Storage Drivers" you can typically ignore the missing settings for `aufs` and `zfs` as long as you don't required to use these, same is true for `devicemapper`. 

![kernel-checkconfig-nano2.jpg](/images/verify-kernel-container-compatibility/kernel-checkconfig-nano2.jpg)

Here I'd also like to present the output as pure ASCII text so you can easily analyse (search, copy&paste) it later.
```bash
pirate@jetson-nano:~$ ./check-config.sh
info: reading kernel config from /proc/config.gz ...

Generally Necessary:
- cgroup hierarchy: properly mounted [/sys/fs/cgroup]
- CONFIG_NAMESPACES: enabled
- CONFIG_NET_NS: enabled
- CONFIG_PID_NS: enabled
- CONFIG_IPC_NS: enabled
- CONFIG_UTS_NS: enabled
- CONFIG_CGROUPS: enabled
- CONFIG_CGROUP_CPUACCT: enabled
- CONFIG_CGROUP_DEVICE: enabled
- CONFIG_CGROUP_FREEZER: enabled
- CONFIG_CGROUP_SCHED: enabled
- CONFIG_CPUSETS: enabled
- CONFIG_MEMCG: enabled
- CONFIG_KEYS: enabled
- CONFIG_VETH: enabled (as module)
- CONFIG_BRIDGE: enabled
- CONFIG_BRIDGE_NETFILTER: enabled (as module)
- CONFIG_NF_NAT_IPV4: enabled (as module)
- CONFIG_IP_NF_FILTER: enabled (as module)
- CONFIG_IP_NF_TARGET_MASQUERADE: enabled (as module)
- CONFIG_NETFILTER_XT_MATCH_ADDRTYPE: enabled (as module)
- CONFIG_NETFILTER_XT_MATCH_CONNTRACK: enabled (as module)
- CONFIG_NETFILTER_XT_MATCH_IPVS: enabled (as module)
- CONFIG_IP_NF_NAT: enabled (as module)
- CONFIG_NF_NAT: enabled (as module)
- CONFIG_NF_NAT_NEEDED: enabled
- CONFIG_POSIX_MQUEUE: enabled

Optional Features:
- CONFIG_USER_NS: enabled
- CONFIG_SECCOMP: enabled
- CONFIG_CGROUP_PIDS: enabled
- CONFIG_MEMCG_SWAP: enabled
- CONFIG_MEMCG_SWAP_ENABLED: enabled
    (cgroup swap accounting is currently enabled)
- CONFIG_BLK_CGROUP: enabled
- CONFIG_BLK_DEV_THROTTLING: enabled
- CONFIG_IOSCHED_CFQ: enabled
- CONFIG_CFQ_GROUP_IOSCHED: missing
- CONFIG_CGROUP_PERF: enabled
- CONFIG_CGROUP_HUGETLB: missing
- CONFIG_NET_CLS_CGROUP: enabled
- CONFIG_CGROUP_NET_PRIO: enabled
- CONFIG_CFS_BANDWIDTH: enabled
- CONFIG_FAIR_GROUP_SCHED: enabled
- CONFIG_RT_GROUP_SCHED: enabled
- CONFIG_IP_NF_TARGET_REDIRECT: missing
- CONFIG_IP_VS: enabled (as module)
- CONFIG_IP_VS_NFCT: enabled
- CONFIG_IP_VS_PROTO_TCP: missing
- CONFIG_IP_VS_PROTO_UDP: missing
- CONFIG_IP_VS_RR: enabled (as module)
- CONFIG_EXT4_FS: enabled
- CONFIG_EXT4_FS_POSIX_ACL: enabled
- CONFIG_EXT4_FS_SECURITY: enabled
- Network Drivers:
  - "overlay":
    - CONFIG_VXLAN: enabled
      Optional (for encrypted networks):
      - CONFIG_CRYPTO: enabled
      - CONFIG_CRYPTO_AEAD: enabled
      - CONFIG_CRYPTO_GCM: enabled
      - CONFIG_CRYPTO_SEQIV: enabled
      - CONFIG_CRYPTO_GHASH: enabled
      - CONFIG_XFRM: enabled
      - CONFIG_XFRM_USER: enabled
      - CONFIG_XFRM_ALGO: enabled
      - CONFIG_INET_ESP: missing
      - CONFIG_INET_XFRM_MODE_TRANSPORT: enabled
  - "ipvlan":
    - CONFIG_IPVLAN: missing
  - "macvlan":
    - CONFIG_MACVLAN: enabled (as module)
    - CONFIG_DUMMY: enabled
  - "ftp,tftp client in container":
    - CONFIG_NF_NAT_FTP: enabled (as module)
    - CONFIG_NF_CONNTRACK_FTP: enabled (as module)
    - CONFIG_NF_NAT_TFTP: enabled (as module)
    - CONFIG_NF_CONNTRACK_TFTP: enabled (as module)
- Storage Drivers:
  - "aufs":
    - CONFIG_AUFS_FS: missing
  - "btrfs":
    - CONFIG_BTRFS_FS: enabled (as module)
    - CONFIG_BTRFS_FS_POSIX_ACL: enabled
  - "devicemapper":
    - CONFIG_BLK_DEV_DM: enabled
    - CONFIG_DM_THIN_PROVISIONING: missing
  - "overlay":
    - CONFIG_OVERLAY_FS: enabled (as module)
  - "zfs":
    - /dev/zfs: missing
    - zfs command: missing
    - zpool command: missing

Limits:
- /proc/sys/kernel/keys/root_maxkeys: 1000000
```


### Conclusion

With these easy steps we've covered in this short blogpost, you're now able to verify if the Linux kernel you're using is able to run Docker, containerd, Kubernetes or k3s in an optimal way.

Just keep this in mind whenever you're discovering some strange errors with your Container Run-Time on a new Linux system. This is especially important when you run Containers on an Embedded Device. We've discovered a lot of missing kernel settings in the early days with the Raspberry Pi. Even today the Raspberry Pi kernel which comes with the default Raspbian is not fully optimized to run Containers, therefore the image built from HypriotOS is still a better alternative when you wish to run Containers on these devices.

And even when Docker runs out-of-the-box on a brandnew device like it does on the Jetson Nano, it's always a good idea to verify the Linux kernel - prior to get into some strange errors.

In a later blogpost we'll optimize the stock Linux kernel for the brand-new NVIDIA Jetson Nano DevKit and we'll show you how to build your own customized kernel for this great board.


### Feedback, please

As always use the comments below to give us feedback and share it on Twitter or Facebook.

Please send us your feedback on our [Gitter channel](https://gitter.im/hypriot/talk) or tweet your thoughts and ideas on this project at [@HypriotTweets](https://twitter.com/HypriotTweets).

Dieter [@Quintus23M](https://twitter.com/Quintus23M)
