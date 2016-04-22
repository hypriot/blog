+++
Categories = ["docker", "raspberry_pi", "GPIO", "Hardware"]
Description = ""
Tags = ["docker", "raspberry_pi", "eletronics", "led"]
date = "2015-04-09T16:49:33+01:00"
title = "Let's get physical with Docker on the Raspberry Pi"
author = "Stefan Scherer"

more_link = "yes"
+++

With Docker on the Raspberry Pi we are able to connect cloud tools with IoT devices. So how can we interact with the real world from inside a Docker container? Let's see and get physical...

<!--more-->

To keep the tutorial simple we will use the binary from the [wiringPi](http://wiringpi.com) project within a Docker container. This command line tool can be used to read and write the GPIO (General Purpose Input/Output) pins of the Raspberry Pi.

We've dockerized the wiringPi binary `gpio` in a very tiny Docker image of about 2 MByte, so pulling this image even on a Raspberry Pi B is still a fast experience.

```bash
docker pull hypriot/rpi-gpio
```

## Turn an LED on and off

In a first little example we just want to turn an LED on and off. You need only a few components to try it yourself.

See the wiring diagram on how to connect the LED and the 220Ω resistor to your Raspberry Pi for the following examples. We use the 11th (BCM GPIO 17 / wiringPi Pin 0) and 9th (Ground) Pin of the Raspberry Pi B/B+ or Pi 2 B.

![wiringPi LED Pin 0](/images/gpio/wiringPi-LED-Pin0_Steckplatine.svg)

And here is the circuit diagram:

![wiringPi LED Pin 0 circuit](/images/gpio/wiringPi-LED-Pin0_Schaltplan.svg)

Now you can use these commands:

### Get status of all GPIOs

```bash
$ docker run --rm --cap-add SYS_RAWIO --device /dev/mem hypriot/rpi-gpio readall
```

The output of this command shows a table with all pins and modes as well as the current states.

```
 +-----+-----+---------+------+---+---Pi 2---+---+------+---------+-----+-----+
 | BCM | wPi |   Name  | Mode | V | Physical | V | Mode | Name    | wPi | BCM |
 +-----+-----+---------+------+---+----++----+---+------+---------+-----+-----+
 |     |     |    3.3v |      |   |  1 || 2  |   |      | 5v      |     |     |
 |   2 |   8 |   SDA.1 | ALT0 | 1 |  3 || 4  |   |      | 5V      |     |     |
 |   3 |   9 |   SCL.1 | ALT0 | 1 |  5 || 6  |   |      | 0v      |     |     |
 |   4 |   7 | GPIO. 7 |   IN | 1 |  7 || 8  | 1 | ALT0 | TxD     | 15  | 14  |
 |     |     |      0v |      |   |  9 || 10 | 1 | ALT0 | RxD     | 16  | 15  |
 |  17 |   0 | GPIO. 0 |   IN | 0 | 11 || 12 | 0 | ALT5 | GPIO. 1 | 1   | 18  |
 |  27 |   2 | GPIO. 2 |   IN | 0 | 13 || 14 |   |      | 0v      |     |     |
 |  22 |   3 | GPIO. 3 |   IN | 0 | 15 || 16 | 0 | IN   | GPIO. 4 | 4   | 23  |
 |     |     |    3.3v |      |   | 17 || 18 | 0 | IN   | GPIO. 5 | 5   | 24  |
 |  10 |  12 |    MOSI | ALT0 | 0 | 19 || 20 |   |      | 0v      |     |     |
 |   9 |  13 |    MISO | ALT0 | 0 | 21 || 22 | 0 | IN   | GPIO. 6 | 6   | 25  |
 |  11 |  14 |    SCLK | ALT0 | 0 | 23 || 24 | 1 | ALT0 | CE0     | 10  | 8   |
 |     |     |      0v |      |   | 25 || 26 | 1 | ALT0 | CE1     | 11  | 7   |
 |   0 |  30 |   SDA.0 |   IN | 1 | 27 || 28 | 1 | IN   | SCL.0   | 31  | 1   |
 |   5 |  21 | GPIO.21 |   IN | 1 | 29 || 30 |   |      | 0v      |     |     |
 |   6 |  22 | GPIO.22 |   IN | 1 | 31 || 32 | 0 | IN   | GPIO.26 | 26  | 12  |
 |  13 |  23 | GPIO.23 |   IN | 0 | 33 || 34 |   |      | 0v      |     |     |
 |  19 |  24 | GPIO.24 |   IN | 0 | 35 || 36 | 0 | IN   | GPIO.27 | 27  | 16  |
 |  26 |  25 | GPIO.25 |   IN | 0 | 37 || 38 | 0 | IN   | GPIO.28 | 28  | 20  |
 |     |     |      0v |      |   | 39 || 40 | 0 | IN   | GPIO.29 | 29  | 21  |
 +-----+-----+---------+------+---+----++----+---+------+---------+-----+-----+
 | BCM | wPi |   Name  | Mode | V | Physical | V | Mode | Name    | wPi | BCM |
 +-----+-----+---------+------+---+---Pi 2---+---+------+---------+-----+-----+
```


### Set mode to output

To turn on LED's or switch other outputs you have to set the corresponding GPIO pin to output mode with

```bash
$ docker run --rm --cap-add SYS_RAWIO --device /dev/mem hypriot/rpi-gpio mode 0 out
```

This has to be done only once after reboot.

### Turn on the LED

Now we can turn on the LED with

```bash
$ docker run --rm --cap-add SYS_RAWIO --device /dev/mem hypriot/rpi-gpio write 0 on
```

### Turn off the LED

or off with
```bash
$ docker run --rm --cap-add SYS_RAWIO --device /dev/mem hypriot/rpi-gpio write 0 off
```

## Read a button from GPIO

In another example we attach a button to the Raspberry Pi and read the state from the 12th pin (BCM GPIO 18, wiringPi Pin 1).
The button is also connected to the 2nd Pin (3.3 V) and the pull down resistor is connected to 9th Pin (Ground).

The wiring diagram shows how to connect all parts. You need a push button, a 1kΩ resistor for pull down and a 10kΩ resistor to connect to the Raspberry Pi.

![wiringPi Button on Pin 1](/images/gpio/wiringPi-Button-Pin1_Steckplatine.svg)

And here is the corresponding circuit diagram:

![wiringPi Button on Pin 1 circuit](/images/gpio/wiringPi-Button-Pin1_Schaltplan.svg)

### Read button state

To get the status of just the 1th GPIO use this command

```bash
$ docker run --rm --cap-add SYS_RAWIO --device /dev/mem hypriot/rpi-gpio read 1
0
```

The command returns `0` or `1` as a result of the input state.

## Conclusion

In this blog post we showed you how easily you can use the GPIO ports of the Raspberry Pi from a Docker container with a simple command line tool.

There also is a more complete Docker image [acencini/rpi-python-serial-wiringpi](https://registry.hub.docker.com/u/acencini/rpi-python-serial-wiringpi/) on the Docker Hub that contains Python and the complete wiringPi2 library to play with.

If you want to learn more about the GPIO pins you can use the excellent [interactive Raspberry Pi Pinout guide](http://pi.gadgetoid.com/pinout) from Gadgetoid.

As always use the comments below to give us feedback and share the blog post on Twitter or Facebook.
