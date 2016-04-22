+++
Categories = ["Docker", "Kitematic", "Windows"]
Tags = ["Docker", "Kitematic", "Windows"]
date = "2015-09-09T00:07:37+02:00"
draft = false
more_link = "yes"
title = "Kitematic meets Windows Docker"

+++

I just want to share some screenshots with you. Today I have played with Kitematic on a Windows Server 2016 TP3 and made it talk to the Windows Docker Engine. Yes, no VirtualBox in between. Just starting native Windows Containers from the Kitematic interface.

<!--more-->

![](/images/kitematic-meets-windows-docker/kitematic-win2016tp3.png-shadow.png)

A closer look at the left column shows a running **mongo** container. Yes, I know, you cannot pull docker images with the Windows Docker Engine at the moment. But I have built a mongo Docker image for Windows with this [Dockerfile](https://github.com/StefanScherer/dockerfiles-windows/blob/master/mongo/3.0/Dockerfile) and created the container by pressing the **Create** button in the Kitematic UI.

![](/images/kitematic-meets-windows-docker/kitematic-mongo.png-shadow.png)

And to show that this is no fake you can see some windows paths in the container logs view:

![](/images/kitematic-meets-windows-docker/kitematic-list.png-shadow.png)

That's all for now.

As always use the comments below to give us feedback and share it on Twitter or Facebook.

Stefan
