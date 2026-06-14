#!/bin/bash

set -ouex pipefail

# thanks to skullbite's Kionite7 some bits and pieces of this script

cd /tmp
git clone --depth 1 https://github.com/mrbvrz/segoe-ui-linux /tmp/segoe
curl -o /usr/share/fonts/lucon.ttf -SsL https://github.com/FSKiller/Microsoft-Fonts/blob/main/lucon.ttf
curl -o /tmp/tv.zip https://www.yohng.com/files/TerminalVector.zip
unzip tv.zip

cp TerminalVector.ttf /usr/share/fonts
cp -r /tmp/segoe/font /usr/share/fonts

fc-cache -f -r -v

dnf install -y gcc gcc-c++ cmake make extra-cmake-modules plasma-workspace-devel libksysguard-devel unzip kvantum qt6-qtmultimedia-devel qt6-qt5compat-devel libplasma-devel qt6-qtbase-devel qt6-qtwayland-devel plasma-activities-devel kf6-kpackage-devel kf6-kglobalaccel-devel qt6-qtsvg-devel wayland-devel plasma-wayland-protocols kf6-ksvg-devel kf6-kcrash-devel kf6-kguiaddons-devel kf6-kcmutils-devel kf6-kio-devel kdecoration-devel kf6-ki18n-devel kf6-knotifications-devel kf6-kirigami-devel kf6-kiconthemes-devel cmake gmp-ecm-devel kf5-plasma-devel libepoxy-devel kwin-devel kf6-karchive kf6-karchive-devel plasma-wayland-protocols-devel qt6-qtbase-private-devel qt6-qtbase-devel kf6-knewstuff-devel kf6-knotifyconfig-devel kf6-attica-devel kf6-krunner-devel kf6-kdbusaddons-devel kf6-sonnet-devel plasma5support-devel plasma-activities-stats-devel polkit-qt6-1-devel qt-devel libdrm-devel kf6-kitemmodels-devel kf6-kstatusnotifieritem-devel kf6-frameworkintegration-devel layer-shell-qt-devel



CUR_DIR=/tmp/vtp

git clone --depth 1 https://gitgud.io/aeroshell/vtp/vistathemeplasma/ $CUR_DIR
cd $CUR_DIR

SU_CMD=
USE_NINJA="-G Ninja"
NINJA_PARAM="--ninja"
LIBEXEC_DIR=libexec
UAC_LIBEXEC_DIR=libexec/kf6

chmod +x install.sh
./install.sh --skip-x11

rm /usr/share/wayland-sessions/plasma.desktop

sed -i "s/#Current=01-breeze-fedora/Current=sddm-theme-mod/g" /etc/sddm.conf
sed -i "s/#CursorTheme=/CursorTheme=aero-drop/g" /etc/sddm.conf

dnf autoremove -y


systemctl disable plasmalogin.service
systemctl enable sddm.service