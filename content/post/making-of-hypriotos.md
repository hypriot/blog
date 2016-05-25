+++
Categories = ["Docker", "Raspberry Pi", "ARM"]
Tags = ["Docker", "Raspberry Pi", "ARM"]
date = "2016-05-25T18:03:32+01:00"
draft = false
more_link = "yes"
title = "Making of HypriotOS"
author = "Stefan Scherer"

+++

Today we have released a new version of HypriotOS "Barbossa" - the SD card image with a ready-to-go Docker toolset for all Raspberry Pi's. Beginning with this release we have **open sourced every step** to build each parts, from the kernel and root filesystem up to the SD card image.

We have also moved every build step out in the cloud to use the "programmable internet" to build and test everything with just a **git push**.

![release process](/images/making-of-hypriotos/hypriotos-release.png)

<!--more-->

This diagram above shows the release process of a new SD card image for any of the new HypriotOS supported ARM boards. We have moved all building steps to Cloud services. This helps us all to build any SD card without the need to have the specific ARM board. And this also **enables the community to contribute** to all our repos with pull requests.

## CI driven builds

To build the SD card images in the Cloud we have chosen a mixture of **Travis CI** and **CircleCI** as the Docker support fits our needs. Only where we need ARM servers to built natively we have our own **Drone** and **Jenkins** servers running on Scaleway C1 servers.

The build process downloads some other artifacts like the root filesystem for the specific ARM CPU type and installs further DEB packages like the **Linux kernel**, the **Docker Engine** and **Docker Compose**.

After each build Travis also runs **Serverspec** tests against the SD card image to have a minimal test of the generated output.

![travis serverspec tests](/images/making-of-hypriotos/travis-serverspec-tests.png)

When we trigger a release build, Travis deploys the newly generated SD card image to the **[GitHub releases](https://github.com/hypriot/image-builder-rpi/releases)** page. You can find releases, as well as pre-releases of upcoming versions there.

## Join the movement

The advantage of open sourcing is that the community can give us feedback and sometimes even start contributing back. The SD card image can be built locally on your Linux or Mac notebook as well. So you also are able to build a SD card image without having the device.

As we love Docker the build process runs in a Docker Container. This simplifies the setup on your local machine. Each GitHub repository has a README with the steps needed to build and test the specific HypriotOS SD card image.

![local build](/images/making-of-hypriotos/hypriotos-local-build.png)

The normal workflow looks like this

  * `git clone` - get the repo you want to build
  * `make docker-machine` - create a local VM with Docker
  * `make sd-image` - build the SD card image within a Docker Container
  * `flash sd-card*.zip` - flash the new SD card image and boot your ARM device.
  * `BOARD=ip make test-integration` - run Serverspec tests if everything is fine

We have added over [200 Serverspec tests](https://github.com/hypriot/image-builder-rpi/tree/master/builder/test-integration/spec) to ensure the Docker tools, Kernel and additional packages are installed correctly. You can even run these tests for the latest release to check if it is working for you as well.
This enables everyone to make changes to the code base and send us Pull Requests without breaking other parts.

The **Pull Requests** are tested with **Travis CI** of course, so we can see if it works well.

![pull request successful](/images/making-of-hypriotos/github-pr-success.png)

As there are several GitHub repositories involved to build the SD card image we use **Waffle.io** to have and overview of all issues, pull requests and tasks to do for a release.

![waffle board](/images/making-of-hypriotos/waffle.png)

## What's next

We also started to add more boards and created new GitHub repos for each. But we focused on the Raspberry Pi to finish the "Barbossa" release. Here is a list of boards we have started to support:

  * [Raspberry Pi Zero, 1, 2, 3](https://github.com/hypriot/image-builder-rpi)
  * [ODROID C1/C1+](https://github.com/hypriot/image-builder-odroid-c1)
  * [ODROID XU3/XU4](https://github.com/hypriot/image-builder-odroid-xu4)
  * [ODROID C2](https://github.com/hypriot/image-builder-odroid-c2)
  * [Banana Pi](https://github.com/hypriot/image-builder-bananapi)
  * [NVIDIA ShieldTV](https://github.com/hypriot/image-builder-nvidia-shieldtv)
  * Pine A64, ...

We will pick one of these boards next to add all features of "Barbossa" to have a great Docker experience with it.
The other boards are still a work in progress - any help is welcome from the community!

As always use the comments below to give us feedback and share it on Twitter or Facebook.

Stefan [@stefscherer](https://twitter.com/stefscherer)
