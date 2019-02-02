#!/bin/sh -x

sudo apt-get remove checkinstall 
sudo apt-get install gettext
git clone https://github.com/giuliomoro/checkinstall
cd checkinstall
sudo make install
