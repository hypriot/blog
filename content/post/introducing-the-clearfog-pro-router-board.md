+++
Categories = ["Docker", "SolidRun", "ClearFog Pro", "ARM", "Marvell", "Armada"]
Tags = ["Docker", "SolidRun", "ClearFog Pro", "ARM", "Marvell", "Armada"]
date = "2016-03-14T23:38:42+01:00"
draft = false
more_link = "yes"
title = "Introducing the new ClearFog Pro Router Board from SolidRun"

+++

Could you imagine to run a standard Linux OS and your applications of choice securely
within Docker containers on a beefy WiFi router at home?

We think this will be possible soon with this new ARM-based router board from SolidRun.
Thus we'll spent a whole blog post series to install our Debian-based HypriotOS
and get Docker running on this Marvell ARMADA powered Single Board Computer (SBC).

So let's get started and for our first episode in this series we'll dive deep into
the technical specifications of the ClearFog Pro in order to get to know this neat
little device.

![ClearFog Pro Overview](/images/clearfog-pro-intro/clearfog-pro-overview.jpg)

But be prepared, this one is really a powerful beast...
<!--more-->

![ClearFog Pro Overview](/images/clearfog-pro-intro/clearfog-pro-overview-01.jpg)


### Technical specifications

The ClearFog is based upon the Marvell ARMADA 380 or 388 processors. The CPU is a
single or dual core ARMv7 processor (Cortex A9) @ up to 1.6 GHz with 1MB L2 cache,
NEON and FPU.

| Features         | ClearFog Base*             | ClearFog Pro               |
|------------------|----------------------------|----------------------------|
| [SoC Model](https://www.solid-run.com/marvell-armada-family/armada-som-system-on-module/)        | ARMADA based A380/A388     | ARMADA based A380/A388     |
| Memory & Storage | 256MB (A380)/1GB (A388)    | 256MB (A380)/1GB (A388)    |
|                  | M.2**                      | M.2                        |
|                  | 8GB microSD                | 8GB microSD                |
|                  | 4GB eMMC (optional)        | 4GB eMMC (optional)        |
| Connectivity     | 1x mSATA/mPCIE             | 2x mSATA/mPCIE             |
|                  | 1x USB 3.0 port            | 1x USB 3.0 port            |
|                  | 2x Port dedicated Ethernet | 1x Port dedicated Ethernet |
|                  | 1x SFP (A388 Only)         | 6x Port switched Ethernet  |
|                  |                            | 1x SFP Ethernet            |
| I/O and Misc.    | Analog Audio               | Analog Audio/TDM module support |
|                  | GPIO Header (mikroBUS)     | GPIO Header (mikroBUS)     |
|                  | Indication LEDs            | Indication LEDs            |
|                  | User Push Buttons          | User Push Buttons          |
|                  | PoE expansion header       | PoE expansion header       |
|                  | RTC Battery                | RTC Battery |
|                  | FTDI (console only), Debug Header | FTDI (console only), Debug Header |
|                  |                            | JTAG Header                |
| OS Support       | Linux Kernel 3.x, OpenWrt, Yocto | Linux Kernel 3.x, OpenWrt, Yocto |
| Power            | Wide range 9-32V           | Wide range 9-32V           |
|                  |                            | Advanced Power Control     |
|                  |                            | Fan Control                |
| Dimensions       | 100mm x 74mm               | 225mm x 100mm              |
*available soon  
**M.2 includes USB 3.0 support (in carrier Base only)

More details can be found at the
[ClearFog Pro](https://www.solid-run.com/marvell-armada-family/clearfog/) product page.

*ClearFog Pro (top view)*
![ClearFog Pro Top View](/images/clearfog-pro-intro/clearfog-pro-components-top-view-1.jpg)

*ClearFog Pro (buttom view)*
![ClearFog Pro Buttom View](/images/clearfog-pro-intro/clearfog-pro-components-bottom-view.jpg)


### Technical highlights

* passive cooling
* all Ethernet ports supporting up to 1GBit/s at least
* the SFP Ethernet port supports up to 2.5GBit/s
* mSATA or miniPCIe mode can be configured
* M.2 slot supports a 2242 form factor M.2 card (22mm x 42mm)


### First impressions

We think you'll get it now - this device is somewhat special.

It's not a real end-user product and it's therefore called a development board. But the
ClearFog Pro is already equipped with some best-in-class components and has a superior
build quality - once you see it in person you'll gonna know what we're talking about.


### Lot's of possibilities

As you now know some of the technical details of the ClearFog Pro, you can clearly
imagine what could be possible with such a board.

So, we're listing here only a few possibilities to start the brain storming...

* a high-speed WiFi router with a 802.11n or 802.11ac miniPCIe card
* a NAS system with mSATA or M.2 SSD disks
* a personal router and firewall
* an ownCloud server
* a streaming server for audio and video tracks
* or maybe all this above at once
* a powerful Docker host with insane network performance

...and finally we'd like to ask you:

*"What would you like to build with a ClearFog Pro?"*


**Update:** new follow-up posts

* Part 2: [Let's run Docker on the ClearFog Pro router board](https://blog.hypriot.com/post/clearfog-pro-part-2-lets-run-docker/)

Please send us your feedback on our [Gitter channel](https://gitter.im/hypriot/talk) or tweet your thoughts and ideas on this project at [@HypriotTweets](https://twitter.com/HypriotTweets).

Dieter [@Quintus23M](https://twitter.com/Quintus23M)

P.S. this ClearFog Pro (ARMADA A388 w/ 1GByte memory) is already hooked up for testing in our labs
![ClearFog Pro Cabled](/images/clearfog-pro-intro/clearfog-pro-cabled.jpg)
