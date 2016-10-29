+++
title = "FAQ"
+++

### What is HypriotOS?
See [this description here](https://blog.hypriot.com/about#hypriotos:6083a88ee3411b0d17ce02d738f69d47).

### On which boards can HypriotOS run?
- [All Raspberry Pis: Zero, 1, 2 and 3](https://github.com/hypriot/image-builder-rpi)
- [ODROID C1+](https://github.com/hypriot/image-builder-odroid-c1)
- [NVIDIA ShieldTV](https://github.com/hypriot/image-builder-nvidia-shieldtv)
- [Olimex Micro board](https://blog.hypriot.com/downloads/)
- [XU 4](https://github.com/hypriot/image-builder-odroid-xu4/releases)</br>
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


</br>
__You think that some important information is missing? [Improve this site on GitHub!](https://github.com/hypriot/blog)__
