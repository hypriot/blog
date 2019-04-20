+++
date = "2019-04-20T09:51:52+02:00"
title = "NVIDIA Jetson Nano - Install Docker Compose"
draft = false
more_link = "yes"
Tags = ["Docker","Nvidia","Jetson","Nano","ARM","64bit","ARM64","AARCH64","Container"]
Categories = ["Docker","Nvidia","Jetson","Nano","ARM","64bit","ARM64","AARCH64","Container"]

+++

In our last blogpost [NVIDIA Jetson Nano Developer Kit - Introduction](https://blog.hypriot.com/post/nvidia-jetson-nano-intro/) we digged into the brand-new **NVIDIA Jetson Nano Developer Kit** and we did found out, that Docker 18.06.1-CE is already pre-installed on this great ARM board.

![Jetson-Nano-Upacked.jpg](/images/nvidia-jetson-nano-intro/Jetson-Nano-Upacked.jpg)

Today, I want to share some more details on how you can easily install Docker Compose on the Jetson Nano.

<!--more-->


### Install Docker Compose

Sadly, there is no binary of [Docker Compose](https://docs.docker.com/compose/) available we could install directly on an ARM 64bit board like the NVIDIA Jetson Nano. If we are looking at the official GitHub release page for Docker Compose https://github.com/docker/compose/releases/tag/1.24.0 there are only binaries provided for Intel x86-64 based operating systems like Linux, macOS and Windows - but nothing for ARM 32bit or 64bit systems.

This isn't too bad, because Docker Compose is based upon Python and maybe it's easier to install if Python is already available on our board. So, let's check this out the easy way.


### Docker Compose is based upon Python

First, check out if Python is already available on the Jetson Nano. As we have a complete Ubuntu 18.04 LTS desktop operation system this is very likely. But let's verify it directly on a shell running on the Nano. This can be done from the desktop terminal app or via a SSH shell.

```bash
pirate@jetson-nano:~$ python --version
Python 2.7.15rc1
```

OK, this looks pretty promising. We do have the Python version 2.7.15rc1 already installed on the Nano.

Let's try to install Docker Compose via Python PIP. So, first we need to install Python PIP itself.
```bash
# first, we have to install Python PIP
$ sudo apt-get update -y
$ sudo apt-get install -y curl
$ curl -sSL https://bootstrap.pypa.io/get-pip.py | sudo python

# verify the installed Python PIP version
pirate@jetson-nano:~$ pip --version
pip 19.0.3 from /usr/local/lib/python2.7/dist-packages/pip (python 2.7)
```

Now, let's try to install Docker Compose via Python PIP. Here we're going to pin the latest version of Docker Compose, which is 1.24.0 of the time of writing this blogpost.
```bash
# install Docker Compose via pip
export DOCKER_COMPOSE_VERSION=1.24.0
sudo pip install docker-compose=="${DOCKER_COMPOSE_VERSION}"
```

But this will throw a lot of error messages because it seems we do miss some required build dependencies. If you're interested here are the full details.
```bash
pirate@jetson-nano:~$ curl -sSL https://bootstrap.pypa.io/get-pip.py | sudo python
DEPRECATION: Python 2.7 will reach the end of its life on January 1st, 2020. Please upgrade your Python as Python 2.7 won't be maintained after that date. A future version of pip will drop support for Python 2.7.
The directory '/home/pirate/.cache/pip/http' or its parent directory is not owned by the current user and the cache has been disabled. Please check the permissions and owner of that directory. If executing pip with sudo, you may want sudo's -H flag.
The directory '/home/pirate/.cache/pip' or its parent directory is not owned by the current user and caching wheels has been disabled. check the permissions and owner of that directory. If executing pip with sudo, you may want sudo's -H flag.
Collecting pip
  Downloading https://files.pythonhosted.org/packages/d8/f3/413bab4ff08e1fc4828dfc59996d721917df8e8583ea85385d51125dceff/pip-19.0.3-py2.py3-none-any.whl (1.4MB)
    100% |████████████████████████████████| 1.4MB 843kB/s
Collecting setuptools
  Downloading https://files.pythonhosted.org/packages/c8/b0/cc6b7ba28d5fb790cf0d5946df849233e32b8872b6baca10c9e002ff5b41/setuptools-41.0.0-py2.py3-none-any.whl (575kB)
    100% |████████████████████████████████| 583kB 761kB/s
Collecting wheel
  Downloading https://files.pythonhosted.org/packages/96/ba/a4702cbb6a3a485239fbe9525443446203f00771af9ac000fa3ef2788201/wheel-0.33.1-py2.py3-none-any.whl
Installing collected packages: pip, setuptools, wheel
Successfully installed pip-19.0.3 setuptools-41.0.0 wheel-0.33.1
pirate@jetson-nano:~$ pip --version
pip 19.0.3 from /usr/local/lib/python2.7/dist-packages/pip (python 2.7)

pirate@jetson-nano:~$ export DOCKER_COMPOSE_VERSION=1.24.0
pirate@jetson-nano:~$ sudo pip install docker-compose=="${DOCKER_COMPOSE_VERSION}"
DEPRECATION: Python 2.7 will reach the end of its life on January 1st, 2020. Please upgrade your Python as Python 2.7 won't be maintained after that date. A future version of pip will drop support for Python 2.7.
The directory '/home/pirate/.cache/pip/http' or its parent directory is not owned by the current user and the cache has been disabled. Please check the permissions and owner of that directory. If executing pip with sudo, you may want sudo's -H flag.
The directory '/home/pirate/.cache/pip' or its parent directory is not owned by the current user and caching wheels has been disabled. check the permissions and owner of that directory. If executing pip with sudo, you may want sudo's -H flag.
Collecting docker-compose==1.24.0
  Downloading https://files.pythonhosted.org/packages/51/56/5745e66b33846e92a8814466c163f165a26fadad8b33afe381e8b6c3f652/docker_compose-1.24.0-py2.py3-none-any.whl (134kB)
    100% |████████████████████████████████| 143kB 2.3MB/s
Collecting cached-property<2,>=1.2.0 (from docker-compose==1.24.0)
  Downloading https://files.pythonhosted.org/packages/3b/86/85c1be2e8db9e13ef9a350aecd6dea292bd612fa288c2f40d035bb750ded/cached_property-1.5.1-py2.py3-none-any.whl
Collecting docopt<0.7,>=0.6.1 (from docker-compose==1.24.0)
  Downloading https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz
Collecting jsonschema<3,>=2.5.1 (from docker-compose==1.24.0)
  Downloading https://files.pythonhosted.org/packages/77/de/47e35a97b2b05c2fadbec67d44cfcdcd09b8086951b331d82de90d2912da/jsonschema-2.6.0-py2.py3-none-any.whl
Collecting backports.ssl-match-hostname>=3.5; python_version < "3.5" (from docker-compose==1.24.0)
  Downloading https://files.pythonhosted.org/packages/ff/2b/8265224812912bc5b7a607c44bf7b027554e1b9775e9ee0de8032e3de4b2/backports.ssl_match_hostname-3.7.0.1.tar.gz
Requirement already satisfied: six<2,>=1.3.0 in /usr/lib/python2.7/dist-packages (from docker-compose==1.24.0) (1.11.0)
Collecting ipaddress>=1.0.16; python_version < "3.3" (from docker-compose==1.24.0)
  Downloading https://files.pythonhosted.org/packages/fc/d0/7fc3a811e011d4b388be48a0e381db8d990042df54aa4ef4599a31d39853/ipaddress-1.0.22-py2.py3-none-any.whl
Collecting requests!=2.11.0,!=2.12.2,!=2.18.0,<2.21,>=2.6.1 (from docker-compose==1.24.0)
  Downloading https://files.pythonhosted.org/packages/ff/17/5cbb026005115301a8fb2f9b0e3e8d32313142fe8b617070e7baad20554f/requests-2.20.1-py2.py3-none-any.whl (57kB)
    100% |████████████████████████████████| 61kB 2.8MB/s
Collecting texttable<0.10,>=0.9.0 (from docker-compose==1.24.0)
  Downloading https://files.pythonhosted.org/packages/02/e1/2565e6b842de7945af0555167d33acfc8a615584ef7abd30d1eae00a4d80/texttable-0.9.1.tar.gz
Collecting dockerpty<0.5,>=0.4.1 (from docker-compose==1.24.0)
  Downloading https://files.pythonhosted.org/packages/8d/ee/e9ecce4c32204a6738e0a5d5883d3413794d7498fe8b06f44becc028d3ba/dockerpty-0.4.1.tar.gz
Collecting enum34<2,>=1.0.4; python_version < "3.4" (from docker-compose==1.24.0)
  Downloading https://files.pythonhosted.org/packages/c5/db/e56e6b4bbac7c4a06de1c50de6fe1ef3810018ae11732a50f15f62c7d050/enum34-1.1.6-py2-none-any.whl
Collecting PyYAML<4.3,>=3.10 (from docker-compose==1.24.0)
  Downloading https://files.pythonhosted.org/packages/9e/a3/1d13970c3f36777c583f136c136f804d70f500168edc1edea6daa7200769/PyYAML-3.13.tar.gz (270kB)
    100% |████████████████████████████████| 276kB 2.9MB/s
Collecting websocket-client<1.0,>=0.32.0 (from docker-compose==1.24.0)
  Downloading https://files.pythonhosted.org/packages/29/19/44753eab1fdb50770ac69605527e8859468f3c0fd7dc5a76dd9c4dbd7906/websocket_client-0.56.0-py2.py3-none-any.whl (200kB)
    100% |████████████████████████████████| 204kB 3.2MB/s
Collecting docker[ssh]<4.0,>=3.7.0 (from docker-compose==1.24.0)
  Downloading https://files.pythonhosted.org/packages/48/68/c3afca1a5aa8d2997ec3b8ee822a4d752cf85907b321f07ea86888545152/docker-3.7.2-py2.py3-none-any.whl (134kB)
    100% |████████████████████████████████| 143kB 3.5MB/s
Collecting functools32; python_version == "2.7" (from jsonschema<3,>=2.5.1->docker-compose==1.24.0)
  Downloading https://files.pythonhosted.org/packages/c5/60/6ac26ad05857c601308d8fb9e87fa36d0ebf889423f47c3502ef034365db/functools32-3.2.3-2.tar.gz
Collecting urllib3<1.25,>=1.21.1 (from requests!=2.11.0,!=2.12.2,!=2.18.0,<2.21,>=2.6.1->docker-compose==1.24.0)
  Downloading https://files.pythonhosted.org/packages/df/1c/59cca3abf96f991f2ec3131a4ffe72ae3d9ea1f5894abe8a9c5e3c77cfee/urllib3-1.24.2-py2.py3-none-any.whl (131kB)
    100% |████████████████████████████████| 133kB 3.2MB/s
Collecting chardet<3.1.0,>=3.0.2 (from requests!=2.11.0,!=2.12.2,!=2.18.0,<2.21,>=2.6.1->docker-compose==1.24.0)
  Downloading https://files.pythonhosted.org/packages/bc/a9/01ffebfb562e4274b6487b4bb1ddec7ca55ec7510b22e4c51f14098443b8/chardet-3.0.4-py2.py3-none-any.whl (133kB)
    100% |████████████████████████████████| 143kB 3.5MB/s
Collecting idna<2.8,>=2.5 (from requests!=2.11.0,!=2.12.2,!=2.18.0,<2.21,>=2.6.1->docker-compose==1.24.0)
  Downloading https://files.pythonhosted.org/packages/4b/2a/0276479a4b3caeb8a8c1af2f8e4355746a97fab05a372e4a2c6a6b876165/idna-2.7-py2.py3-none-any.whl (58kB)
    100% |████████████████████████████████| 61kB 5.8MB/s
Collecting certifi>=2017.4.17 (from requests!=2.11.0,!=2.12.2,!=2.18.0,<2.21,>=2.6.1->docker-compose==1.24.0)
  Downloading https://files.pythonhosted.org/packages/60/75/f692a584e85b7eaba0e03827b3d51f45f571c2e793dd731e598828d380aa/certifi-2019.3.9-py2.py3-none-any.whl (158kB)
    100% |████████████████████████████████| 163kB 353kB/s
Collecting docker-pycreds>=0.4.0 (from docker[ssh]<4.0,>=3.7.0->docker-compose==1.24.0)
  Downloading https://files.pythonhosted.org/packages/f5/e8/f6bd1eee09314e7e6dee49cbe2c5e22314ccdb38db16c9fc72d2fa80d054/docker_pycreds-0.4.0-py2.py3-none-any.whl
Collecting paramiko>=2.4.2; extra == "ssh" (from docker[ssh]<4.0,>=3.7.0->docker-compose==1.24.0)
  Downloading https://files.pythonhosted.org/packages/cf/ae/94e70d49044ccc234bfdba20114fa947d7ba6eb68a2e452d89b920e62227/paramiko-2.4.2-py2.py3-none-any.whl (193kB)
    100% |████████████████████████████████| 194kB 3.2MB/s
Collecting pyasn1>=0.1.7 (from paramiko>=2.4.2; extra == "ssh"->docker[ssh]<4.0,>=3.7.0->docker-compose==1.24.0)
  Downloading https://files.pythonhosted.org/packages/7b/7c/c9386b82a25115cccf1903441bba3cbadcfae7b678a20167347fa8ded34c/pyasn1-0.4.5-py2.py3-none-any.whl (73kB)
    100% |████████████████████████████████| 81kB 3.2MB/s
Collecting bcrypt>=3.1.3 (from paramiko>=2.4.2; extra == "ssh"->docker[ssh]<4.0,>=3.7.0->docker-compose==1.24.0)
  Downloading https://files.pythonhosted.org/packages/ce/3a/3d540b9f5ee8d92ce757eebacf167b9deedb8e30aedec69a2a072b2399bb/bcrypt-3.1.6.tar.gz (42kB)
    100% |████████████████████████████████| 51kB 8.4MB/s
  Installing build dependencies ... error
  Complete output from command /usr/bin/python /usr/local/lib/python2.7/dist-packages/pip install --ignore-installed --no-user --prefix /tmp/pip-build-env-qwOdIW/overlay --no-warn-script-location --no-binary :none: --only-binary :none: -i https://pypi.org/simple -- setuptools wheel "cffi>=1.1; python_implementation != 'PyPy'":
  DEPRECATION: Python 2.7 will reach the end of its life on January 1st, 2020. Please upgrade your Python as Python 2.7 won't be maintained after that date. A future version of pip will drop support for Python 2.7.
  The directory '/home/pirate/.cache/pip/http' or its parent directory is not owned by the current user and the cache has been disabled. Please check the permissions and owner of that directory. If executing pip with sudo, you may want sudo's -H flag.
  The directory '/home/pirate/.cache/pip' or its parent directory is not owned by the current user and caching wheels has been disabled. check the permissions and owner of that directory. If executing pip with sudo, you may want sudo's -H flag.
  Collecting setuptools
    Downloading https://files.pythonhosted.org/packages/c8/b0/cc6b7ba28d5fb790cf0d5946df849233e32b8872b6baca10c9e002ff5b41/setuptools-41.0.0-py2.py3-none-any.whl (575kB)
  Collecting wheel
    Downloading https://files.pythonhosted.org/packages/96/ba/a4702cbb6a3a485239fbe9525443446203f00771af9ac000fa3ef2788201/wheel-0.33.1-py2.py3-none-any.whl
  Collecting cffi>=1.1
    Downloading https://files.pythonhosted.org/packages/93/1a/ab8c62b5838722f29f3daffcc8d4bd61844aa9b5f437341cc890ceee483b/cffi-1.12.3.tar.gz (456kB)
  Collecting pycparser (from cffi>=1.1)
    Downloading https://files.pythonhosted.org/packages/68/9e/49196946aee219aead1290e00d1e7fdeab8567783e83e1b9ab5585e6206a/pycparser-2.19.tar.gz (158kB)
  Installing collected packages: setuptools, wheel, pycparser, cffi
    Running setup.py install for pycparser: started
      Running setup.py install for pycparser: finished with status 'done'
    Running setup.py install for cffi: started
      Running setup.py install for cffi: finished with status 'error'
      Complete output from command /usr/bin/python -u -c "import setuptools, tokenize;__file__='/tmp/pip-install-XfNg4G/cffi/setup.py';f=getattr(tokenize, 'open', open)(__file__);code=f.read().replace('\r\n', '\n');f.close();exec(compile(code, __file__, 'exec'))" install --record /tmp/pip-record-lpvT6b/install-record.txt --single-version-externally-managed --prefix /tmp/pip-build-env-qwOdIW/overlay --compile:
      Package libffi was not found in the pkg-config search path.
      Perhaps you should add the directory containing `libffi.pc'
      to the PKG_CONFIG_PATH environment variable
      No package 'libffi' found
      Package libffi was not found in the pkg-config search path.
      Perhaps you should add the directory containing `libffi.pc'
      to the PKG_CONFIG_PATH environment variable
      No package 'libffi' found
      Package libffi was not found in the pkg-config search path.
      Perhaps you should add the directory containing `libffi.pc'
      to the PKG_CONFIG_PATH environment variable
      No package 'libffi' found
      Package libffi was not found in the pkg-config search path.
      Perhaps you should add the directory containing `libffi.pc'
      to the PKG_CONFIG_PATH environment variable
      No package 'libffi' found
      Package libffi was not found in the pkg-config search path.
      Perhaps you should add the directory containing `libffi.pc'
      to the PKG_CONFIG_PATH environment variable
      No package 'libffi' found
      running install
      running build
      running build_py
      creating build
      creating build/lib.linux-aarch64-2.7
      creating build/lib.linux-aarch64-2.7/cffi
      copying cffi/ffiplatform.py -> build/lib.linux-aarch64-2.7/cffi
      copying cffi/vengine_gen.py -> build/lib.linux-aarch64-2.7/cffi
      copying cffi/setuptools_ext.py -> build/lib.linux-aarch64-2.7/cffi
      copying cffi/verifier.py -> build/lib.linux-aarch64-2.7/cffi
      copying cffi/backend_ctypes.py -> build/lib.linux-aarch64-2.7/cffi
      copying cffi/vengine_cpy.py -> build/lib.linux-aarch64-2.7/cffi
      copying cffi/pkgconfig.py -> build/lib.linux-aarch64-2.7/cffi
      copying cffi/recompiler.py -> build/lib.linux-aarch64-2.7/cffi
      copying cffi/api.py -> build/lib.linux-aarch64-2.7/cffi
      copying cffi/cparser.py -> build/lib.linux-aarch64-2.7/cffi
      copying cffi/__init__.py -> build/lib.linux-aarch64-2.7/cffi
      copying cffi/cffi_opcode.py -> build/lib.linux-aarch64-2.7/cffi
      copying cffi/error.py -> build/lib.linux-aarch64-2.7/cffi
      copying cffi/lock.py -> build/lib.linux-aarch64-2.7/cffi
      copying cffi/model.py -> build/lib.linux-aarch64-2.7/cffi
      copying cffi/commontypes.py -> build/lib.linux-aarch64-2.7/cffi
      copying cffi/_cffi_include.h -> build/lib.linux-aarch64-2.7/cffi
      copying cffi/parse_c_type.h -> build/lib.linux-aarch64-2.7/cffi
      copying cffi/_embedding.h -> build/lib.linux-aarch64-2.7/cffi
      copying cffi/_cffi_errors.h -> build/lib.linux-aarch64-2.7/cffi
      running build_ext
      building '_cffi_backend' extension
      creating build/temp.linux-aarch64-2.7
      creating build/temp.linux-aarch64-2.7/c
      aarch64-linux-gnu-gcc -pthread -DNDEBUG -g -fwrapv -O2 -Wall -Wstrict-prototypes -fno-strict-aliasing -Wdate-time -D_FORTIFY_SOURCE=2 -g -fdebug-prefix-map=/build/python2.7-ytvI67/python2.7-2.7.15~rc1=. -fstack-protector-strong -Wformat -Werror=format-security -fPIC -DUSE__THREAD -DHAVE_SYNC_SYNCHRONIZE -I/usr/include/ffi -I/usr/include/libffi -I/usr/include/python2.7 -c c/_cffi_backend.c -o build/temp.linux-aarch64-2.7/c/_cffi_backend.o
      c/_cffi_backend.c:15:10: fatal error: ffi.h: No such file or directory
       #include <ffi.h>
                ^~~~~~~
      compilation terminated.
      error: command 'aarch64-linux-gnu-gcc' failed with exit status 1

      ----------------------------------------
  Command "/usr/bin/python -u -c "import setuptools, tokenize;__file__='/tmp/pip-install-XfNg4G/cffi/setup.py';f=getattr(tokenize, 'open', open)(__file__);code=f.read().replace('\r\n', '\n');f.close();exec(compile(code, __file__, 'exec'))" install --record /tmp/pip-record-lpvT6b/install-record.txt --single-version-externally-managed --prefix /tmp/pip-build-env-qwOdIW/overlay --compile" failed with error code 1 in /tmp/pip-install-XfNg4G/cffi/

  ----------------------------------------
Command "/usr/bin/python /usr/local/lib/python2.7/dist-packages/pip install --ignore-installed --no-user --prefix /tmp/pip-build-env-qwOdIW/overlay --no-warn-script-location --no-binary :none: --only-binary :none: -i https://pypi.org/simple -- setuptools wheel "cffi>=1.1; python_implementation != 'PyPy'"" failed with error code 1 in None
```

After some investigation we're able to identify the missing build dependencies and here are the required commands to install it.
```bash
# install Docker Compose build dependencies for Ubuntu 18.04 on aarch64
$ sudo apt-get install -y libffi-dev
$ sudo apt-get install -y python-openssl
```


### Install Docker Compose via Python PIP

TL;DR These are all commands you need to install Docker Compose on a freshly installed NVIDIA Jetson Nano.

```bash
# step 1, install Python PIP
$ sudo apt-get update -y
$ sudo apt-get install -y curl
$ curl -sSL https://bootstrap.pypa.io/get-pip.py | sudo python

# step 2, install Docker Compose build dependencies for Ubuntu 18.04 on aarch64
$ sudo apt-get install -y libffi-dev
$ sudo apt-get install -y python-openssl

# step 3, install latest Docker Compose via pip
$ export DOCKER_COMPOSE_VERSION=1.24.0
$ sudo pip install docker-compose=="${DOCKER_COMPOSE_VERSION}"
```


### Conclusion

Finally we have the latest available Docker Compose version 1.24.0 installed on the NVIDIA Jetson Nano. It just takes a few minutes.

```bash
pirate@jetson-nano:~$ docker-compose version
docker-compose version 1.24.0, build 0aa5906
docker-py version: 3.7.2
CPython version: 2.7.15rc1
OpenSSL version: OpenSSL 1.1.0g  2 Nov 2017

pirate@jetson-nano:~$ docker-compose --version
docker-compose version 1.24.0, build 0aa5906
```


### Another Pro-Tip on using Docker command line interface

As we have seen in the last blogpost, we have to use sudo when we're calling a docker command in the shell. This can be easy resolved, we only have to issue the following command ones.
```bash
pirate@jetson-nano:~$ sudo usermod -aG docker pirate
```

Next, log out and log in again or just start a new shell and we don't have to use sudo any more for our docker commands.
```bash
pirate@jetson-nano:~$ docker version
Client:
 Version:           18.06.1-ce
 API version:       1.38
 Go version:        go1.10.1
 Git commit:        e68fc7a
 Built:             Fri Jan 25 14:35:17 2019
 OS/Arch:           linux/arm64
 Experimental:      false

Server:
 Engine:
  Version:          18.06.1-ce
  API version:      1.38 (minimum version 1.12)
  Go version:       go1.10.1
  Git commit:       e68fc7a
  Built:            Thu Jan 24 10:49:48 2019
  OS/Arch:          linux/arm64
  Experimental:     false
```


### Feedback, please

As always use the comments below to give us feedback and share it on Twitter or Facebook.

Please send us your feedback on our [Gitter channel](https://gitter.im/hypriot/talk) or tweet your thoughts and ideas on this project at [@HypriotTweets](https://twitter.com/HypriotTweets).

Dieter [@Quintus23M](https://twitter.com/Quintus23M)