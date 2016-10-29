+++
Tags = ["docker", "raspberry-pi", "arm", "docker-image", "iot", "internet-of-things", "dockerfile"]
date = "2015-08-26T02:55:55+02:00"
title = "Better be prepared for the ARMed IoT flood and port Docker apps to ARM"
more_link = "yes"
+++

The great ARMed flood has begun. Especially for the sake of the IoT, every day new tiny devices pop up all around the world. And since most of these devices are build on top of the ARM architecture, with each new device, ARM gets more important compared to the x86 architecture proposed by Intel/AMD. Maybe you even need to run your next app on ARM! Thus better be prepared and port apps to ARM, it's basically just one step to take.

<!--more-->

In comparison to the x86 CPU architecture, ARM supports low power consumption by design, not just as a feature. When thinking of a sensor network at your home, you don't wanna change the battery of all your sensors every week. Well, think of any device that profits from low power consumption, which does not need the CPU power of a sumo wrestler. As with sumo wrestlers, computers cluttered with resources lack the flexibility needed in today's IT, and the resources of their built in x86 CPU often are barely needed.

Speaking of the number of devices: Some say we will have 20, some say 50 billion connected IoT devices by 2020, where most of them will be ARMed. Well, least let's conclude: It will be a flooding number of them.

Fair enough, so let's start making apps compatible to ARM. To do so, you only need to make sure that the binaries of your apps are compiled explicitly for the ARM architecture. Thus, porting an app to ARM basically means to change the binaries to ARM compatible ones. Let's do it!


## Get started with Docker for an easy porting example

Of course, we use [Docker](https://www.docker.com/). And in the world of Docker, apps are described by Dockerfiles, like recipes for making cakes. Thus, when we wanna ARM an app, we only change its recipe, i.e. its Dockerfile. So make sure you know about the commands in Dockerfiles with the help of the [Dockerfile reference at Docker](https://docs.docker.com/reference/builder/).

From now on, let's better refer to an app as a **service** because often a Dockerfile or a docker-compose file is a recipe for a collection of apps which are combined to a service. Thus a service is described by one or many apps.

In order to directly apply the necessary steps, we go through an example. In this example, we wanna port the [Apache webserver](http://httpd.apache.org/) to ARM.

As hardware for our example, we use a Raspberry Pi, which is one of the most popular ARM devices for developers. Of course, as operating system we use our [SD Card image](/downloads/) that provides Docker on the Raspberry Pi by just [flashing it to a SD card and booting it](https://github.com/hypriot/flash).


## Let's ARM it!

First, search for a Dockerfile that describes the service you wanna ARM. In most cases, Dockerfiles reside on the [Dockerhub](https://hub.docker.com/explore/) or on [Github](https://github.com/).

When choosing a Dockerfile, make sure you can check the following three prerequisites:

  - Take the one with the most stars, the most popular one, or the ones tagged with  "official". In addition, prefer the less complex ones if possible.
  - Take a Dockerfile that is based on Ubuntu or a Debian based image. To evaluated this, check what's in the Dockerfile after the `FROM` command. Any of `debian` or `ubuntu` is fine.
  - Pay attention to the license. Some licenses forbid to copy and change a Dockerfile.

For Apache, we found a small and popular Dockerfile [here](https://hub.docker.com/r/eboraas/apache/~/dockerfile/). We check the Dockerfile if the three prerequisites in the list we above are met. Here, the Dockerfile is based on Debian, it seems clean and there's no license given that restricts the usage of this work.

Note that every now and then there are mistakes in Dockerfiles. Therefore we recommend to test the Docker images on your x86 machine before porting it. In case you encounter any errors, the performance advantage of an x86 machine makes debugging much faster than on your ARM machine. See the [Docker docs to install Docker](http://docs.docker.com/installation/) on your machine. It's fast and painless.

Thus, we test the chosen Dockerfile for Apache on a x86 machine. The `docker run` command to do this is given in the repo description on the Dockerhub. In advance we had to add the tag `wheezy` (read the next chapter when you are curious about the `wheezy` here).

```docker run -p 80:80 -p 443:443 -d eboraas/apache:wheezy```

When the Docker command completed, point your browser to `http://<IP OF YOUR PI>:80/`. You should see the default page of Apache:

![port_dockerfiles_to_arm](/images/port_dockerfiles_to_arm/apache_default_x86.png)

Next, let's move to the target machine running on ARM. Copy the content of the Dockerfile as is to your ARM machine.

In our case, we log into the Raspberry Pi ([get help from our getting started guide](/getting-started-with-docker-on-your-arm-device/)) and copy the content of the Dockerfile to the machine. For this, on the machine, we use the `vim` editor by executing

```vim Dockerfile```

Paste the content.

Then make sure that the content is formatted as it is on the website, e.g. any command should be at the beginning of a new line etc.

After formatting, this is how the Dockerfile should look like:

```
FROM eboraas/debian:stable
MAINTAINER Ed Boraas <ed@boraas.ca>

RUN apt-get update && apt-get -y install apache2 && apt-get clean
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2

RUN /bin/ln -sf ../sites-available/default-ssl /etc/apache2/sites-enabled/001-default-ssl
RUN /bin/ln -sf ../mods-available/ssl.conf /etc/apache2/mods-enabled/
RUN /bin/ln -sf ../mods-available/ssl.load /etc/apache2/mods-enabled/

EXPOSE 80
EXPOSE 443
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
```

Now we need to change all binaries that are used in this Dockerfile to ARM compatible ones. In general, there are two locations that need to be adjusted:

  - The **FROM field in the Dockerfile**, which defines the software layer our service will inherit from. Here we change `debian:jessie` to `resin/rpi-raspbian:wheezy`. Then of course, replace the `MAINTAINER` with your name and email address.
  - The **binaries of the apps that are being downloaded**. In our case, we do not need to change anything because the binary, which is `apache2` is downloaded via the `apt-get install` command. This command is already architecture sensitive, i.e. it downloads only compatible binaries to the target machine.

Finally, save the Dockerfile. Try if the Dockerfile works by creating ...

```docker build -t rpi-apache . ```

... and starting a Docker image:

```docker run -p 80:80 -d rpi-apache```

Now, when you point your browser to the IP address of your ARM machine, you should see the same default page of Apache's as when you started the image on x86 before.

**CONGRATULATIONS! You ARMed your first service!** Now you have the basic understanding to ARM more services! In case you encounter any error, get help in the next chapter. We cross our fingers for you!

*Note*: After you successfully ported a service, you can push it to the Dockerhub, so that other people can use it. In addition make sure to put `rpi-` in front of the Docker image's name. This declares it as a Raspberry Pi compatible image and therefore also as an ARM compatible service. It will make the life easier for people looking for ARMed services on the Dockerhub.


## Debugging hints to ARM a service

  - **Remove any command you do not need to run the service**. In our Apache example, you can delete everything regarding SSL if you do not need it. This already might solve some problems.
  - **Make sure, that all binaries used are pointing to ARM compatible ones**. If there is no compiled ARM binary available, you might need to compile it yourself.
  - **Check other tags**. You may have noticed that in the porting example above we explicitly defined the tag `wheezy` in the `Docker run` command. Why? With the tag `stable` as it was defined in the original Dockerfile, the Docker image will not work. The reason for this is a common problem, which arises when Dockerfiles are not updated regularly: At the time the author created this Dockerfile, `stable` pointed to Debian Wheezy. This worked out fine. However, meanwhile Debian Jessy has been released which ships updated versions of software as well. This invisibly changes the Dockerfile, because `apt-get install apache2` now installs the latest version of Apache. This updated version of Apache is controlled by commands other than the ones given in the Dockerfile. This causes Apache to crash. So this Dockerfile simply has not been updated yet to the newer commands of the updated version of Apache. Thus, try other tags in your Dockerfile – they might just work!
  - **Search for ADD commands** that copy files from the host into the container. Sometimes you need to download these files in advance. Refer to the instructions of the repository, especially look for links to the authors code base , e.g. at Github
  - **Check the 'docker run' command in the Dockerhub repo info**. If there are any depending containers (defined via `--link` parameter), you need porting these images to ARM too. Also check if someone else already ported the depending images you look for.
  - **Try to resolve any other errors by asking an online search engine**. Often, you are not the first one having this problem.


## Optimize the Dockerfile (optional)

Optimizing the Dockerfile does have several advantages: It often makes it smaller, i.e. you need less time to download packages and less disk space on your machine. Further, you gain a better overview over the Dockerfile's structure which simplifies debugging. In the following, we give some recommendations of how to optimize a Dockerfile:

  - **Format it nicely.** Put commands only at the beginning of a line. Add line breaks with `\` and combine commands if possible. See this example:

```
RUN  	apt-get update && \
	apt-get -y install apache2 && \
	apt-get clean

...

EXPOSE 80,443
```

  - **Again, remove any commands that are not needed**, i.e. avoid downloading and installing packages that will not be used.
  - **At the end of a Dockerfile, remove any files that are useless**, e.g. execute `apt-get autoremove && apt-get clean` after installing several packages.
  - **Also, refer to these blog posts that provide more hints (advanced)**
    - [How to create the smallest possible docker image](http://blog.xebia.com/2015/06/30/how-to-create-the-smallest-possible-docker-container-of-any-image/)
    - If you have a service in Go:
      - [Static Go binaries with Docker on OSX](https://developer.atlassian.com/blog/2015/07/osx-static-golang-binaries-with-docker/)
      - [Automatically build static Go binaries and put them into containers](https://github.com/aerofs/gockerize)
      - [Smaller Docker containers for Go apps](https://joeshaw.org/smaller-docker-containers-for-go-apps/)


Use the comments below to share your experiences. Also, join the discussions in the [community channel](https://gitter.im/hypriot/talk).

We wish **happy porting parties**!

Mathias & Andreas
