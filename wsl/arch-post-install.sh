#!/bin/bash

# Post install script for Arch Linux (on WSL) called by the ps-arch-wsl ps module
# More info at https://github.com/scottmckendry/ps-arch-wsl

cd ~
mkdir git -p && cd git
git clone https://github.com/scottmckendry/dots && cd dots
./setup.sh
