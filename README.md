# multisense-distro
Module to build all required CRL Multisense SL dependencies - to run the driver

System Dependencies
-------------------

We use Ubuntu 14.04, to install common dependencies:

    sudo apt-get install build-essential libglib2.0-dev openjdk-6-jdk python-dev


LCM Dependency
--------------

LCM (v1.3.1) is a required dependency which must be installed from source. It can be retrieved from http://lcm-proj.github.io/

::

    wget https://github.com/lcm-proj/lcm/releases/download/v1.3.1/lcm-1.3.1.zip
    unzip lcm-1.3.1.zip
    cd lcm-1.3.1
    ./configure
    make
    sudo make install

Building
--------

To build:

    git submodule update --init
    make

consider adding build/bin to your PATH variable:

  export PATH=your-path-to/multisense-distro/build/bin:$PATH


Running the Device
------------------
Create a new connection from the Network Manager, say called "multisense". Settings should be:
. General: don't automatically connect when available
. Ethernet: set MTU=9000
. ipv4 settings:
      method=Manual
      ip address = 10.66.171.20 (i.e. not the device IP address, 21)
      netmask = 255.255.255.0
      gateway = 10.66.171.1

Then save settings and switch to the new multisense network (with the ethernet cable from the sensor connected to the computer). Alternatively you can run ifconfig with these options on eth0 or appropriate network interface.

To test the device is present:

    ping 10.66.171.21

