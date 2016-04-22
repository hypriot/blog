+++
Categories = ["docker", "raspberry_pi", "GPIO", "NeoPixels", "Hardware", "LED", "Electronics"]
Tags = ["docker", "raspberry_pi"]
date = "2015-04-14T13:25:33+01:00"
title = "Drive NeoPixels in Docker on Raspberry Pi"
author = "Stefan Scherer"

more_link = "yes"
+++

In our [last blog post](/post/lets-get-physical/) we showed you how to interact with the GPIO ports and how to turn on one LED. Now for some more magic lights we create a little Node.js application that drives a NeoPixel LED strip from Adafruit in a Docker container.

<!--more-->

Thanks to the latest improvements now both Raspberry Pi B/B+ and the new Pi 2 B can  drive the NeoPixel LED strips from Adafruit with just a level shifter. So it's time to put this into Docker for easier deployment.

The NeoPixel (or WS2812) LED's are programmable RGB LED's that receive their RGB value with a single serial wire.

## Wiring

Let's have a look at the wiring first. The Raspberry Pi can create the serial signal on GPIO Pin 18 trough PWM/DMA. But the signal level has to be shifted from 3.3V to 5V for the LED strip. I have used a Adafruit Level Shifter Breakout Board, but a 74AHCT125 level converter could be used as well.

![wiring diagram](/images/neopixel/rpi-levelshifter-neopixel_Steckplatine.png)

**Do not power the NeoPixels directly from your Raspberry Pi as the 5V output could not source enough current to light many pixels. This could damage your Raspberry Pi!** For my tests with only eight pixels it is ok to use the 5V from the Pi, but be warned!

## The code

First we create the `package.json` file with a dependency to the `rpi-ws281x-native` Node.js module that supports all Raspberry Pi versions to drive the NeoPixels.

### package.json

```json
{
  "name": "rpi-node-neopixel-example",
  "private": true,
  "version": "0.0.1",
  "description": "Node.js NeoPixel app in docker",
  "author": "hypriot.com",
  "dependencies": {
    "rpi-ws281x-native": "0.4.0"
  }
}
```

### server.js

Now we implement a Node.js sample that does some color magic. We have reduced the brightness of the LED's a little bit.

```javascript
var ws281x = require('rpi-ws281x-native');

var NUM_LEDS = parseInt(process.argv[2], 10) || 8,
    pixelData = new Uint32Array(NUM_LEDS);

var brightness = 128;

ws281x.init(NUM_LEDS);


var lightsOff = function () {
  for (var i = 0; i < NUM_LEDS; i++) {
    pixelData[i] = color(0, 0, 0);
  }
  ws281x.render(pixelData);
  ws281x.reset();
}

var signals = {
  'SIGINT': 2,
  'SIGTERM': 15
};

function shutdown(signal, value) {
  console.log('Stopped by ' + signal);
  lightsOff();
  process.nextTick(function () { process.exit(0); });
}

Object.keys(signals).forEach(function (signal) {
  process.on(signal, function () {
    shutdown(signal, signals[signal]);
  });
});

// ---- animation-loop
var offset = 0;
setInterval(function () {
  for (var i = 0; i < NUM_LEDS; i++) {
    pixelData[i] = wheel(((i * 256 / NUM_LEDS) + offset) % 256);
  }

  offset = (offset + 1) % 256;
  ws281x.render(pixelData);
}, 1000 / 30);

console.log('Rainbow started. Press <ctrl>+C to exit.');

// generate rainbow colors accross 0-255 positions.
function wheel(pos) {
  pos = 255 - pos;
  if (pos < 85) { return color(255 - pos * 3, 0, pos * 3); }
  else if (pos < 170) { pos -= 85; return color(0, pos * 3, 255 - pos * 3); }
  else { pos -= 170; return color(pos * 3, 255 - pos * 3, 0); }
}

// generate integer from RGB value
function color(r, g, b) {
  r = r * brightness / 255;
  g = g * brightness / 255;
  b = b * brightness / 255;
  return ((r & 0xff) << 16) + ((g & 0xff) << 8) + (b & 0xff);
}
```

### Dockerfile

The `Dockerfile` is very simple here as we use the `onbuild` version of our [hypriot/rpi-iojs](https://registry.hub.docker.com/u/hypriot/rpi-iojs/) Docker image.

```
FROM hypriot/rpi-iojs:onbuild
```

## Build the Docker image

We now have all parts together and are ready to build the docker image with this command

```bash
$ docker build -t node-neopixel .
```

## Run the Docker container

Now it is time to turn on the NeoPixel LED's by running the container

```bash
$ docker run --cap-add SYS_RAWIO --device /dev/mem -d node-neopixel
```

On a Raspberry Pi 2 you have to give the container more privileges. So you have to use this command instead

```bash
$ docker run --privileged -d node-neopixel
```

![Let there be lights!](/images/neopixel/neopixel640.gif)

You can find the complete Node.js example on GitHub at [https://github.com/hypriot/rpi-node-neopixel-example](https://github.com/hypriot/rpi-node-neopixel-example).

## Conclusion

Now you are ready to start your NeoPixel project on your Raspberry Pi and deploy it with Docker.

To learn more about NeoPixels head over to the excellent [Adafruit's NeoPixel Überguide](https://learn.adafruit.com/adafruit-neopixel-uberguide/overview).

As always use the comments below to give us feedback and share it on Twitter or Facebook.
