+++
Categories = ["Docker", "Raspberry Pi", "ARM", "Travis"]
Tags = ["Docker", "Raspberry Pi", "ARM", "Travis"]
date = "2017-01-10T07:25:23+02:00"
draft = false
more_link = "yes"
title = "Setup a simple CI pipeline to build Docker images for ARM"

+++

In last November I did an experiment: Can we build Docker images for ARM on ordinary cloud CI services that only provide Intel CPU's?

The idea was to get rid of self hosted CI build agents that you have to care for. If you want to provide an ARM Docker image for an open source project your task is to build it and not to setup and maintain a whole pipeline for it.

![GitHub + YAML = ARM Docker image](/images/setup-simple-ci-pipeline-for-arm-images/github_yaml_arm.png)

<!--more-->

### Background

We at Hypriot have created several Dockerfiles for open source tools like MySQL, Traefik and so on to make them available as Docker images for your ARM devices.

Building such images and maintaining them over a longer period of time you have to care for updates. We are happy to receive pull requests from our community that help us updating the Dockerfiles.
But from time to time our ARM CI pipeline went offline and we had to put in some time and effort to fix the pipeline. There were pull requests lying around for some time without any CI checks.

To get out of this trap I wanted a simpler CI pipeline without self hosted build agents. There are several cloud CI services like Travis, Codeship, Circle and so on, but they all only offer you Intel based CPU's. But they have one thing in common: Just add a YAML file to your GitHub repo, connect it to their CI servers and you are done. There must be a way to use this for our ARM builds.

### QEMU for the rescue

There are some blog posts how to use QEMU to emulate ARM on Intel CPU's and many have even tried to build Docker images. But there were several steps needed to set up everything and it looked very complex.

But after some hours of investigation I found out that all comes down to just two things:

1. An Intel binary of QEMU for ARM must exist in the base Docker image
2. The QEMU binary must be registered in the CI build agent


Fortunately both steps can be done in a very simple way.

### Base image with QEMU binary

The Raspbian Docker images from Resin already have the QEMU binary in it. It seems that they also build images on Intel machines and this is very

So if you use

```Dockerfile
FROM resin/rpi-raspbian
```

you are done with the first step. But what about Alpine? Well we have created a similar - still small - Docker image [hypriot/rpi-alpine](https://github.com/hypriot/rpi-alpine) that uses the "official" armhf/alpine image and just append the QEMU binary. If you want to build ARM Alpine images just use

```Dockerfile
FROM hypriot/rpi-alpine
```

### Register QEMU

I'll show you how we use Travis CI to build ARM images. But if you prefer another cloud CI services that offers Docker builds, it should be the same.

The next step is to register QEMU in the build agent. There is a Docker image available that can do this for us in just one line:

```bash
docker run --rm --privileged multiarch/qemu-user-static:register --reset
```

That's it. Just add this line to your `.travis.yml` and you can build ARM Docker images.

### Travis builds MySQL ARM image

So now put all pieces together and have a look at the final `.travis.yml` file that is used to build the [hypriot/rpi-mysql](https://github.com/hypriot/rpi-mysql) Docker image for ARM.

```
sudo: required
services:
- docker
language: bash
script:
# prepare qemu
- docker run --rm --privileged multiarch/qemu-user-static:register --reset
# build image
- docker build -t hypriot/rpi-mysql .
# test image
- docker run hypriot/rpi-mysql mysql --version
# push image
- >
  if [ "$TRAVIS_BRANCH" == "master" ] && [ "$TRAVIS_PULL_REQUEST" == "false" ]; then
    docker login -u="$DOCKER_USER" -p="$DOCKER_PASS"
    TAG=$(grep "ENV MYSQL_VERSION" Dockerfile | awk 'NF>1{print $NF}')
    docker tag hypriot/rpi-mysql hypriot/rpi-mysql:$TAG
    docker push hypriot/rpi-mysql:$TAG
    docker push hypriot/rpi-mysql
  fi
```

The only difference to an Intel build is to just register QEMU here. The rest is activating Docker builds and do a simple docker build, test, push of that image.


### Conclusion

You only have to remember two things to let the cloud build your ARM images:

1. `FROM resin/rpi-raspbian`
2. `docker run --rm --privileged multiarch/qemu-user-static:register --reset`

We are using this setup for more and more GitHub repos to gain speed and respond to pull requests much faster.

We also are using [matrix builds](https://github.com/hypriot/rpi-node/blob/33d6ea9bebeca9bf31abac1b5dbc66a9f9902184/.travis.yml#L5-L8) for all major versions of Node.js to build new Docker images with Travis.

### Feedback, please

As always use the comments below to give us feedback and share it on Twitter or Facebook.

Please send us your feedback on our [Gitter channel](https://gitter.im/hypriot/talk) or tweet your thoughts and ideas on this project at [@HypriotTweets](https://twitter.com/HypriotTweets).

Stefan [@stefscherer](https://twitter.com/stefscherer)
