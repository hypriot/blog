+++
Categories = ["Docker", "Conference", "Talk", "Speaker","Cluster", "Cloud Computing", "IoT"]
Tags = ["Docker", "Conference", "Talk", "Speaker", "Cluster", "Cloud Computing", "IoT"]
date = "2016-06-06T18:03:34+01:00"
more_link = "yes"
title = "Learning about Cloud Computing with Hypriot Cluster Lab at ICT 2016"
+++

Our cooperation with University of Bamberg pays off once again: We had the chance to present our Hypriot Cluster Lab at [ICT 2016](http://ict-2016.org/), the International Conference on Telecommunications. There, we were able to show the Hypriot Cluster Lab to the attendees, who were mainly scientific researchers from all over the globe.

![IoT-requirements](/images/ict-2016-greece/ict_logo.jpg)

<!--more-->

We built the Hypriot Cluster Lab as lab environment that allows to easily teach about clustering and cloud computing. At the conference, the Hypriot Cluster Lab piqued lots of interest, so we are confident that it will be used more and more in educational institutions.

Now, after the show, we are publishing the [presentation slides](/images/ict-2016-greece/ICT-Presentation.pdf). However, the slides are not throughout self-explanatory, so we've also written down what we've presented to the audience back in Greece.


IoT requires "Expansion to small"
---------------------------------
Building cloud computing infrastructures with big servers is well understood. Even large cloud infrastructures powered by container technology are commonly in use. One of the pioneers to mention here is Google with its container-based cloud platform [Kubernetes](http://kubernetes.io/).

However, the uprising Internet of Things (IoT) will not allow to equip the edge of the network such as sensor networks in smart home/grid/production environments with big servers only. There, you especially need small devices with less computational power and energy demand. These devices require to be small and cheap enough to install up to several thousands of them in a smart environment, thereby creating sensor networks. For example think of sensor networks on wind farms:

![IoT-requirements](/images/ict-2016-greece/wind.jpg)
<div style="padding-left:34.4em; font-size: smaller">Image courtesy of [European Wind Energy Association](https://www.flickr.com/photos/ewea/16577911487/in/photolist-rfW8w8-ipD2tM-ipC49q-7d8FqR-ipCNzR-ipC1dU-ipBRBC-ipCGWN-ipCkFm-njeuG6-ipCC31-ipCnPv-ayYLge-ipCJ61-ayYMmc-ipBGVN-ayYHLH-9mZuNi-ayYMzX-oWbzp6-ayYK6n-7ZaHBQ-q8T7wm-az2p4W-8LowiB-az2o8s-ayYJJt-az2p2f-3euhCb-ayYMWD-ayYNgZ-ayYL48-az2riu-6YiWvR-az2qkC-ayYMev-az2rxU-az2on1-ayYK2V-ayYHrz-az2oru-az2ov7-az2oeW-qQMUJN-auVRqy-az2oDm-ayYM8Z-i5kW85-ayYJTV-az2rCE)</div>

At this point, Hypriot Cluster Lab (HCL) comes into play:

> __HCL is a proof of concept that building clusters using container technology (in our case: Docker) also works well on small devices, not only on big servers.__

This "Expansion to Small" was the theme of the ICT 2016, which made HCL a perfect fit to the conference's agenda.


HCL makes a tangible IoT-like cluster affordable
-----------------------------------------------------
HCL is not only a proof of concept that clustering with container technology on IoT devices works, it also serves a second purpose: It is cheap enough to be used as a learning platform to play with clustering or cloud computing on your desk. The minimal hardware configuration requires three Raspberry Pis plus accessoires, which is affordable for everyone to get their hands on a real, tangible cluster. We've already seen lecturers, students and pupils getting started on the HCL with different topics related to cloud computing, e.g. playing with micro services or load balancing. Some use cases can be found [in one of our repos here](https://github.com/hypriot/rpi-cluster-lab-demos).

Even though the HCL is intended to be used as a tool to learn, its containing concepts are applicable for promising IoT software solutions. Comparing IoT's general requirements for hard- and software that I identified in my bachelor thesis ([details here](https://medium.com/@mathiasrenner/docker-container-virtualization-and-the-internet-of-things-bachelor-thesis-a6bc783b81fa#.f09czsq2e)) show that many of those aspects are already visible in the HCL:

![IoT-requirements](/images/ict-2016-greece/iot-requirements.jpg)


Conclusion
----------
All in all, the conference was an enriching experience. Discussing with scientific researches and professors from many different countries resulted in high-grade feedback and inspirations of how we can further improve the HCL. Particularly interesting were the discussions after some glasses of good, greek wine. They resulted in less high-grade feedback, but much fun instead :)

Thus, we look forward to also attend more conferences. Well, the next conference is already set: In two weeks, three of the Hypriot team (Dieter, Stefan and myself) will attend DockerCon in Seattle, USA! We will give workshops and talks, so we are happy to meet you there! For everyone who won't attend: Stay tuned, we try to share as much as possible via our channels.

Last but not least, I give special thanks Marcel Großmann (research assistant at University of Bamberg) for his great support. He is not only providing high quality feedback to our work, meanwhile he also contributes to the HCL. Not to mention that he also provides the venue for our Docker Meetups. His continunous support is worth a virtual applause!


As always, use the comments below to give us feedback and share this post on Twitter, Google or Facebook.

[@MathiasRenner](https://twitter.com/MathiasRenner)
