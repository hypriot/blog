+++
Categories = ["Docker", "Kubernetes","K8s", "Clustering", "Cluster","Raspberry Pi", "Cloud Computing"]
Tags = ["Docker", "Kubernetes","K8s", "Clustering", "Cluster","Raspberry Pi", "Cloud Computing"]
date = "2016-12-26T18:03:34+01:00"
more_link = "yes"
title = "Setup of Kubernetes on a Raspberry Pi Cluster the official way"
+++

Kubernetes (K8s) shares the pole position with Docker in the category "orchestration solutions for Raspberry Pi cluster". However it's setup process has always been elaborate. Now, with it's recent release, Kubernetes changed this game completely and can be up and running within no time.

I am very happy to announce that this blog post has been written in collaboration with Lucas Käldström, an independent maintainer of Kubernetes. He contributed most in order to bring Kubernetes to the ARM architecture.


![SwarmClusterHA](/images/kubernetes-setup-cluster/raspberry-pi-cluster.png)


<!--more-->


Why Kubernetes?
---------------
As shown in my recent [talk](http://www.slideshare.net/MathiasRenner/high-availability-performance-of-kubernetes-and-docker-swarm-on-a-raspberry-pi-cluster/), there are many software suites available to manage a cluster of computers. There is Mesos, OpenStack, Hadoop YARN, Nomad... just to name a few.

However, at Hypriot we have always been in love with tiny devices. So when working with an orchestrator, the maximum power we wanna use is what's provided by a Raspberry Pi. Why? We have IoT networks in mind that will hold a large share in tomorrow's IT infrastructure. At their edges, the power required for large orchestrators simply is not available.

This boundary of resources leads to several requirements that need to be checked before we start getting our hands dirty with an orchestrator:

  - **Lightweight:** Software should be fit on a Raspberry Pi or smaller. As proofed in my talk above, K8s painlessly runs on a Raspberry Pi.
  - **Compatible to ARM:** Since the ARM CPU architecture is designed for low energy consumption but still able to deliver a decent portion of power, the Raspberry Pi runs an ARM CPU. Thanks to Lucas, K8s is ARM compatible.
  - **General purpose:** Hadoop or Apache Spark are great for data analysis. But what if your use case changes? We prefer general purpose software that allows to run **anything**. K8s uses the Docker container engine that allows to run whatever you want.
  - **Production ready:** Since we compare K8s against a production ready Docker suite, let's be fair and only choose equivalents. The ARM compatibility of Kubernetes is not considered as production ready. However, Kubernetes itself is, and it won't take long to also consider the ARM branch as production ready.

So, Kubernetes seems to be a compelling competitor to Docker. Let's get our hands on it!


Wait – what about Kubernetes-on-ARM?
---------------
If you followed the discussion of K8s on ARM for some time, you probably know about Lucas' project [kubernetes-on-arm](https://github.com/luxas/kubernetes-on-arm). Since the beginning of the movement to bring K8s on ARM in 2015, this project has always been the most stable and updated.

However, now Lucas' contributions have successfully been merged into official K8s repositories, such that there is point any more for using the kubernetes-on-arm project. In fact, the features of that project are far behind of what's now implemented in the official repos.

So if you're up to using K8s, please stick to the official repos now. And as of documentation, the following setup how-to can be considered as official for K8s on ARM.


Setup step 1 of 2: Flash HypriotOS on your SD cards
-------------------
As hardware, take at least two Raspberry Pis and make sure they are connected to each other and to the Internet.

First, we need an operating system. Download and flash [HypriotOS](https://github.com/hypriot/image-builder-rpi/releases). It's recommend to do all (download and flash) in one by using our [flash tool](https://github.com/hypriot/flash):

```
flash --hostname node01 https://github.com/hypriot/image-builder-rpi/releases/download/v1.1.3/hypriotos-rpi-v1.1.3.img.zip
```

Provision all Raspberry Pis you have like this and boot them up.

Afterwards, SSH into the Raspberry Pis with
```
ssh pirate@node01.local
```

The password `hypriot` will grant you access.


Setup step 2 of 2: Install Kubernetes
-------------------------

The installation requries root privileges. Retrieve them by
```
sudo su -
```

To install K8s and its dependencies, four separate commands are required. To simplify, a [gist](https://gist.github.com/MathiasRenner/e74f91e23b987424f36a5e61acd4f3e8) helps to crunch the four command into just the following one:

```
curl -s https://gist.githubusercontent.com/MathiasRenner/e74f91e23b987424f36a5e61acd4f3e8/raw/1001f8a1b4ad43aac3b3b1b15cc9b8dd5c1616c4/install.sh | bash
```

After the previous command has been finished, initialize K8s on the master node with

```
kubeadm init --pod-network-cidr 10.244.0.0/16
```
It is important that you add the `--pod-network-cidr` command as given here. //TODO why?

If you are connected via WIFI instead of Ethernet, add `--api-advertise-addresses=<ip-address>` as parameter to  `kubeadm init` in order to publish Kubernetes' API via WiFi.

After K8s has been initialized, the last lines of your terminal should look like this:


![init](/images/kubernetes-setup-cluster/init.png)


Next, as told by that output, let all other nodes join the cluster via the given `kubeadm join` command. In this case, it is:
```
kubeadm join --token=bb14ca.e8bbbedf40c58788 192.168.0.34
```

After some seconds, you should see all nodes in your cluster when executing the following on the master node:
```
kubectl get nodes
```

![k8S](/images/kubernetes-setup-cluster/get-nodes.png)

Finally, we need to setup flannel as the network driver. Meanwhile, [Weave](https://www.weave.works/products/weave-net/) is also available, but here we just present flannel:
```
curl -sSL https://rawgit.com/coreos/flannel/master/Documentation/kube-flannel.yml | sed "s/amd64/arm/g" | kubectl create -f -
```

![k8S](/images/kubernetes-setup-cluster/flannel.png)


Start a small service
-------------------
Let's just run a simple service so see if the cluster actually can publish a service! Run:

```
kubectl run hypriot --image=hypriot/rpi-busybox-httpd --replicas=3 --port=80
```
This command starts the set of containers from the image **hypriot/rpi-busybox-httpd** and defines the port the container listens on at **80**. The service will be **replicated with 3 containers**.

Next, publish the containers to be accessible outside the cluster:

```
kubectl expose deployment hypriot --port 80 --type NodePort
```

In contrast to Docker, K8s itself does not provide an option to define a specific port that listens for a service. According to Lucas is this a design decision, since routing of incoming requests to the front server of the cluster should be handled by a loadbalancer or a webserver. Also see [ingress](http://kubernetes.io/docs/user-guide/ingress/), an extension of K8s that can be configured to route incoming requests to the correct target.

K8s assigns ports in the range of 30000-32767 to a deployment (think of 'deployment' as a 'Docker service'). To get the port of the service that we just created, run:

```
kubectl get svc hypriot
```

In the output, look at the column **PORT(S)**. The second number is the port at which you can access the service from outside the cluster like at **http://\<ip of the a node>:\<port>**, like http://192.168.0.34:32444 .

//TODO add screenshot of browser



If you don't see a website there yet, run
```
kubectl get pods
```
... and check if the Status for all pods is //TODO

If the pods are not ready yet, wait a bit until they are up and running.


Tear down the cluster
--------------------
If you wanna reset the whole cluster to the state after a fresh install, just run this on each nodes:
```
kubeadm reset
```


Optional: Deploy K8s dashboard
---------------------
The dashboard is a wonderful interface to visualize the state of the cluster. Start it with

```
curl -sSL https://rawgit.com/kubernetes/dashboard/master/src/deploy/kubernetes-dashboard.yaml | sed "s/amd64/arm/g" | kubectl create -f -
```

The following command provides the port where the dashboard is accessible from outside the cluster:
```
kubectl -n kube-system get service kubernetes-dashboard -o template --template="{{ (index .spec.ports 0).nodePort }}"
```


As always, use the comments below to give us feedback and share this post on Twitter, Google or Facebook.

[MathiasRenner](https://twitter.com/MathiasRenner) and [Lucas Käldström](https://twitter.com/kubernetesonarm)
