#!/bin/bash

set -ouex pipefail

dnf5 -y copr enable yalter/niri
dnf5 install -y sddm niri

dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y
dnf install -y fastfetch steam tailscale firefox zoxide

systemctl enable podman.socket
