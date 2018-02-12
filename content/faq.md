+++
title = "FAQ"
+++

### What is HypriotOS?

See [this description here](/about#hypriotos:6083a88ee3411b0d17ce02d738f69d47).

### On which boards can HypriotOS run?

* [All Raspberry Pis: Zero, 1, 2 and 3](https://github.com/hypriot/image-builder-rpi)
* [ODROID C1/C1+](https://github.com/hypriot/image-builder-odroid-c1)
* [ODROID C2](https://github.com/hypriot/image-builder-odroid-c2)
* [NVIDIA ShieldTV](https://github.com/hypriot/image-builder-nvidia-shieldtv)
* [Olimex Micro board](/downloads/)
* [ODROID XU 4](https://github.com/hypriot/image-builder-odroid-xu4/releases)</br>
* You know another device that works fine with HypriotOS? [Extend the list on GitHub!](https://github.com/hypriot/blog)

### Is there an easy way to flash the image of HypriotOS onto a SD card?

Yes, check out our [flash tool](https://github.com/hypriot/flash), which makes the flashing process super easy and fast.

### Default Credentials

The default credentials for the image are user **pirate** with password **hypriot**.

### Connection via SSH to a fresh HypriotOS, I get `connection reset by peer`.

After all, Re-flashing of the SD cards is all that we've experienced as a solution for this error.

### How can I change the hostname?

Starting with HypriotOS 1.7 we use [cloud-init](http://cloudinit.readthedocs.io/en/0.7.9/index.html) to automatically change some settings on every boot.

Just edit the `/boot/user-data` file with an editor

```bash
sudo nano /boot/user-data
```

and change the line with `hostname:`

```yaml
hostname: black-pearl
```

After a reboot the device boots up with the new hostname. See more details about the `user-data]` file in the blog post [Bootstrapping a Cloud with Cloud-Init and HypriotOS](https://blog.hypriot.com/post/cloud-init-cloud-on-hypriot-x64/).

### How can I boot a Raspberry Pi Zero?

To configure and boot a Raspberry Pi Zero without a mini HDMI adapter you can prepare everything before the first boot. To turn on the onboard WiFi you have to disable the UART which is used by default to connect to your RPi with an USB2Serial adapter.

Run our flash script with the following options to have a wireless out-of-the-box experience on first boot.

```
flash --bootconf config-no-uart.txt --userdata wifi.yaml hypriotos-rpi-v1.7.1.img.zip
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
#cloud-config

# Set your hostname here, the manage_etc_hosts will update the hosts file entries as well
hostname: black-pearl
manage_etc_hosts: true

# You could modify this for your own user information
users:
  - name: pirate
    gecos: "Hypriot Pirate"
    sudo: ALL=(ALL) NOPASSWD:ALL
    shell: /bin/bash
    groups: users,docker,video
    plain_text_passwd: hypriot
    lock_passwd: false
    ssh_pwauth: true
    chpasswd: { expire: false }

package_upgrade: false

# # WiFi connect to HotSpot
# # - use `wpa_passphrase SSID PASSWORD` to encrypt the psk
write_files:
  - content: |
      allow-hotplug wlan0
      iface wlan0 inet dhcp
      wpa-conf /etc/wpa_supplicant/wpa_supplicant.conf
      iface default inet dhcp
    path: /etc/network/interfaces.d/wlan0
  - content: |
      ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
      update_config=1
      network={
      ssid="your-ssid"
      psk="your-preshared-key"
      proto=RSN
      key_mgmt=WPA-PSK
      pairwise=CCMP
      auth_alg=OPEN
      }
    path: /etc/wpa_supplicant/wpa_supplicant.conf

# These commands will be ran once on first boot only
runcmd:
  # Pickup the hostname changes
  - 'systemctl restart avahi-daemon'

  # Activate WiFi interface
  - 'ifup wlan0'
```

After turning on your Raspberry Pi Zero it should be connected to your WiFi and reachable at `black-pearl.local` (or your hostname of choice).

</br>
__You think that some important information is missing? [Improve this site on GitHub!](https://github.com/hypriot/blog)__
