+++
Categories = ["Docker", "Conference", "Talk", "Speaker","Cluster"]
Tags = ["Docker", "Raspberry Pi", "ARM"]
date = "2016-05-25T18:03:34+01:00"
draft = false
more_link = "yes"
title = "Cloud Computing Learning platform Hypriot Cluster Lab at ICT 2016"
+++

Our cooperation with University of Bamberg pays off once again: We had the chance to present our Hypriot Cluster Lab (HCL) at [ICT 2016](http://ict-2016.org/), the International Conference on Telecommunications. The conference attendees were mainly scientific researchers from all over the globe. Thus, HCL as a tool to learn about computer cloud computing could not get closer to representatives of the education sector.

Now, after the show, we publish the [presentation slides](/images/ict-2016-greece/ICT-Presentation.pdf). However, the slides are not throughout self-explanatory, so we also write down what we've presented to the audience.

![IoT-requirements](/images/ict-2016-greece/ict_logo.jpg)

<!--more-->


IoT requires "Expansion to small"
---------------------------------
Building clusters by connecting big servers powered by container technology is well understood and implemented for many years now. However, the uprising Internet of Things (IoT) will not allow to equip the edge of smart environments, i.e. sensor networks in smart home/grid/production, with big servers only. There, you especially need small devices with less computational power, which are cheap enough to install up to several thousands of them, thereby creating sensor networks.

At this point, HCL comes into play:

> HCL is a proof of concept that building clusters using container technology (in our case: Docker) also works well on small devices, not only on big servers.

This "Expansion to Small" was the theme of the ICT 2016, which made HCL a perfect fit to the conference's agenda.


HCL is about Cloud Computing – and also about the IoT
--------------------------------------------
HCL also serves a second purpose: It can be used as a cheap learning platform to play with clustering or cloud computing. The minimal hardware configuration requires three Raspberry Pis plus accessoires, which is affordable for everyone to get their hands on a real, physical cluster. We've already seen lecturers, students and pupils getting started on the HCL with different topics related to cloud computing, e.g. playing with micro services or distributed databases. A set of ready-to-go use cases can be found [here](https://github.com/hypriot/rpi-cluster-lab-demos).

Even though the HCL is intended to be used as a tool to learn, its containing concepts are applicable for promising IoT software solutions. Comparing IoT's general requirements for hard- and software that I identified in my bachelor thesis ([details here](https://medium.com/@mathiasrenner/docker-container-virtualization-and-the-internet-of-things-bachelor-thesis-a6bc783b81fa#.f09czsq2e)) against the functionalities of HCL reveals that HCL's feature set is almost complete:

![IoT-requirements](/images/ict-2016-greece/iot-requirements.png)

This checklist shows that HCL (software) e.g. on Raspberry Pis (hardware) implements many concepts required in the IoT. So everyone who is both keen on touching the IoT and learning about cloud computing can thereby kill two birds with one stone.


Sharing HCL use cases
-------------
For the ones of you who like to think in practical, real world terms, see the following photo as a use case of a HCL-like software that implements the missing features. Each wind turbine hosts a multitude of sensors, which are organized in clusters...   

![IoT-requirements](/images/ict-2016-greece/wind.jpg)
<div style="padding-left:18.8em; font-size: smaller">Image courtesy of [European Wind Energy Association](https://www.flickr.com/photos/ewea/16577911487/in/photolist-rfW8w8-ipD2tM-ipC49q-7d8FqR-ipCNzR-ipC1dU-ipBRBC-ipCGWN-ipCkFm-njeuG6-ipCC31-ipCnPv-ayYLge-ipCJ61-ayYMmc-ipBGVN-ayYHLH-9mZuNi-ayYMzX-oWbzp6-ayYK6n-7ZaHBQ-q8T7wm-az2p4W-8LowiB-az2o8s-ayYJJt-az2p2f-3euhCb-ayYMWD-ayYNgZ-ayYL48-az2riu-6YiWvR-az2qkC-ayYMev-az2rxU-az2on1-ayYK2V-ayYHrz-az2oru-az2ov7-az2oeW-qQMUJN-auVRqy-az2oDm-ayYM8Z-i5kW85-ayYJTV-az2rCE)</div>

What about you – where do you use the HCL?

Share your projects with us in the comments below and spred the word via Twitter, Facebook or Google+.

[@MathiasRenner](https://twitter.com/MathiasRenner)
