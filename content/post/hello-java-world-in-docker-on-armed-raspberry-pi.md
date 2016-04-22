+++
Categories = ["docker", "raspberry_pi", "Java", "arm"]
Tags = ["docker", "raspberry_pi", "java", "arm"]
date = "2015-04-14T20:16:11+02:00"
more_link = "yes"
title = "10 minutes - no - 10 seconds to run a Java Hello World on Raspberry Pi - thanks to Docker on ARM"
draft = true
+++

You will need just four commands to run a Java “Hello World” on your Pi. For the first time it will take a coffee break. For the second time it will take a coffee gulp.
And running your own Java app on ARM does not take longer. See how it works!

<!--more-->

## Prepare your Pi

Only if you haven’t done it yet: Get Docker running on your Pi. Follow these steps to catch up on this:
LINK-TO-POST

## Log into your Pi and clone our Hello-Java-World repo:

```
git clone https://github.com/hypriot/rpi-java-hello-world
```

## Navigate to the freshly cloned files
```
cd rpi-java-hello-world/
```

## Crate the image and tag it
```
docker build -t java-hello .
```

If you are not logged in as `root`, you have to put `sudo` in front of all docker commands.

This command takes roughly 10 Minutes. You might wonder about the headline now... Well, the `docker build` command downloads and configures all the necessary software to be able to compile and run Java. Especially the download and installing process of the Java binaries takes almost the full 10 Minutes.
However, since the download needs to be done only once, after the first time, the tasks the command triggers are reduced to the configuration step. And this is done in even less than 10 seconds!

## Run the HelloWorld app
As final step, run the container which will compile and run the java app automatically.

```
docker run -e "app=HelloWorld" java-hello /bin/bash /src/compile-and-run-java-app.sh
```

## Run YOUR app
To run your own app, you need to change just two things compared to the hello world example:

   - put your Java code into `src/java`
   - modify the `docker run` command above by setting the name of the app after `app=` to the name of the `.java` file which contains the main method - but omit the `.java` file extension. That's it!


## Troubleshooting
To identify a problem, we suggest, you compile and run the app stepwise.

### At first, dive into the container
```
docker run -e "app=HelloWorld" -it java-hello
```

You will receive a new command prompt showing the ID of your container.

### Compile source code
```
javac HelloWorld.java
```

### Run the app
```
java HelloWorld  
```


## Inspired to move on?
Did we motivate you to try out more than this Hello World? Which Java app did start on your Pi? As always, We look forward to your feedback! Please let us know about any problems you encounter or any ideas you have for improvements!


-- Mathias Renner
