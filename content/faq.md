+++
title = "FAQ"
+++

### What is HypriotOS?
See [this description here](/about#hypriotos:6083a88ee3411b0d17ce02d738f69d47).

### On which boards can HypriotOS run?
- [All Raspberry Pis: Zero, 1, 2 and 3](https://github.com/hypriot/image-builder-rpi)
- [ODROID C1/C1+](https://github.com/hypriot/image-builder-odroid-c1)
- [ODROID C2](https://github.com/hypriot/image-builder-odroid-c2)
- [NVIDIA ShieldTV](https://github.com/hypriot/image-builder-nvidia-shieldtv)
- [Olimex Micro board](/downloads/)
- [ODROID XU 4](https://github.com/hypriot/image-builder-odroid-xu4/releases)</br>
- You know another device that works fine with HypriotOS? [Extend the list on GitHub!](https://github.com/hypriot/blog)

### Is there an easy way to flash the image of HypriotOS onto a SD card?
Yes, check out our [flash tool](https://github.com/hypriot/flash), which makes the flashing process super easy and fast.

### Default Credentials
The default credentials for the image are user **pirate** with password **hypriot**.

### Connection via SSH to a fresh HypriotOS, I get `connection reset by peer`.
After all, Re-flashing of the SD cards is all that we've experienced as a solution for this error.

### How can I change the hostname?
We use [device-init](https://github.com/hypriot/device-init) to automatically change some settings on every boot.

Just edit the `/boot/device-init.yaml` file with an editor

```bash
sudo nano /boot/device-init.yaml
```

and change the line with `hostname:`

```yaml
hostname: "black-pearl"
```

After a reboot the device boots up with the new hostname. See more details about the [device-init.yaml](https://github.com/hypriot/device-init#the-bootdevice-inityaml) file.

### How can I boot a Raspberry Pi Zero?

To configure and boot a Raspberry Pi Zero without a mini HDMI adapter you can prepare everything before the first boot. To turn on the onboard WiFi you have to disable the UART which is used by default to connect to your RPi with an USB2Serial adapter.

Run our flash script with the following options to have a wireless out-of-the-box experience on first boot.

```
flash --bootconf config-no-uart.txt --config wifi.yaml hypriotos-rpi-v1.4.0.img.zip
```

You need two config files that will be copied after flashing the SD card.

config-no-uart.txt

```
hdmi_force_hotplug=1
enable_uart=0

# camera settings, see http://elinux.org/RPiconfig#Camera
start_x=1
disable_camera_led=1
gpu_mem=128

# Enable audio (added by raspberrypi-sys-mods)
dtparam=audio=on
```

wifi.yaml
```yaml
hostname: black-pearl
wifi:
  interfaces:
    wlan0:
      ssid: "MyNetwork"
      password: "secret_password"
```

After turning on your Raspberry Pi Zero it should be connected to your WiFi and reachable at `black-pearl.local` (or your hostname of choice).

</br>
__You think that some important information is missing? [Improve this site on GitHub!](https://github.com/hypriot/blog)__
