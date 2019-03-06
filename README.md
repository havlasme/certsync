certsync
========


Installation
------------

import the `apt.havlas.me` repository key

```bash
wget -qO - https://certsync.apt.havlas.me/debian/KEY.gpg | sudo apt-key add -
```

setup the `apt.havlas.me` repository

```bash
echo "deb https://certsync.apt.havlas.me/debian/ $(lsb_release -cs) main" | sudo tee -a /etc/apt/sources.list.d/apt.havlas.me.list > /dev/null
```

update the apt package index, and install the `certsync` package

```bash
sudo apt-get update
sudo apt-get install certsync
```
