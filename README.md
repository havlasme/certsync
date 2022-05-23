certsync
========

[![Apache-2.0 license][license-image]][license-link]

An SSL certificate synchronization utility.

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

License
-------

[Apache-2.0][license-link]

Author Information
------------------

Created by [Tomáš Havlas](https://havlas.me/).

[license-image]: https://img.shields.io/badge/license-Apache2.0-blue.svg?style=flat-square
[license-link]: LICENSE
