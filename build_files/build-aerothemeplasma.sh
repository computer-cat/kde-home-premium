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

dnf install -y libksysguard-devel plasma-workspace-devel unzip kvantum qt6-qtmultimedia-devel qt6-qt5compat-devel libplasma-devel qt6-qtbase-devel qt6-qtwayland-devel plasma-activities-devel kf6-kpackage-devel kf6-kglobalaccel-devel qt6-qtsvg-devel wayland-devel plasma-wayland-protocols kf6-ksvg-devel kf6-kcrash-devel kf6-kguiaddons-devel kf6-kcmutils-devel kf6-kio-devel kdecoration-devel kf6-ki18n-devel kf6-knotifications-devel kf6-kirigami-devel kf6-kiconthemes-devel cmake gmp-ecm-devel kf5-plasma-devel libepoxy-devel kwin-devel kf6-karchive kf6-karchive-devel plasma-wayland-protocols-devel qt6-qtbase-private-devel qt6-qtbase-devel kf6-knewstuff-devel kf6-knotifyconfig-devel kf6-attica-devel kf6-krunner-devel kf6-kdbusaddons-devel kf6-sonnet-devel plasma5support-devel plasma-activities-stats-devel polkit-qt6-1-devel qt-devel libdrm-devel kf6-kitemmodels-devel kf6-kstatusnotifieritem-devel kf6-frameworkintegration-devel



CUR_DIR=/tmp/atp

git clone --depth 1 https://github.com/aeroshell-desktop/aerothemeplasma.git $CUR_DIR
cd $CUR_DIR

SU_CMD=
USE_NINJA="-G Ninja"
NINJA_PARAM="--ninja"
LIBEXEC_DIR=libexec
UAC_LIBEXEC_DIR=libexec/kf6

#chmod +x install.sh
#./install.sh --skip-x11

# I hardcode the install.sh script in order to pull from atp's github mirror, as it is not currently correctly able to clone currently

CUR_DIR=${PWD}

SU_CMD=sudo
if [[ -z "$(command -v $SU_CMD)" ]]; then
    SU_CMD=doas
    if [[ -z "$(command -v $SU_CMD)" ]]; then
        echo "Neither sudo or doas were detected on the system."
        exit
    fi
fi


if [ -z $LIBEXEC_DIR ]; then
    LIBEXEC_DIR=lib
    UAC_LIBEXEC_DIR=lib
fi

if [[ "$(command -v dnf)" ]]; then # Automatically change for Fedora
    LIBEXEC_DIR=libexec
    UAC_LIBEXEC_DIR=libexec/kf6
fi

mkdir -p repos
mkdir -p manifest
cd repos

# libplasma last
git clone https://github.com/aeroshell-desktop/libplasma.git libplasma
cd libplasma
git pull
cmake -DCMAKE_INSTALL_PREFIX=/usr -B build . || exit 1
cmake --build build || exit 1
$SU_CMD cmake --install build || exit 1
cp build/install_manifest.txt "$CUR_DIR/manifest/libplasma_install_manifest.txt"
cd "$CUR_DIR/repos"

# uac-polkit-agent
git clone https://github.com/aeroshell-desktop/uac-polkit-agent.git uac-polkit-agent
cd uac-polkit-agent
git pull
cmake -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_INSTALL_LIBEXECDIR=$UAC_LIBEXEC_DIR -B build . || exit 1
cmake --build build || exit 1
$SU_CMD cmake --install build || exit 1
cp build/install_manifest.txt "$CUR_DIR/manifest/uac-polkit-agent_install_manifest.txt"
cd "$CUR_DIR/repos"

# SMOD
git clone https://github.com/aeroshell-desktop/smod.git smod
cd smod
git pull
bash install.sh $@
cp build/install_manifest.txt "$CUR_DIR/manifest/smod_install_manifest.txt"
cp smodglow/build-wl/install_manifest.txt "$CUR_DIR/manifest/smodglow_install_manifest.txt"
cd "$CUR_DIR/repos"

# Aeroshell Workspace
git clone https://github.com/aeroshell-desktop/aeroshell-workspace.git aeroshell-workspace
cd aeroshell-workspace
git pull
cmake -DCMAKE_INSTALL_PREFIX=/usr -B build . || exit 1
cmake --build build || exit 1
$SU_CMD cmake --install build || exit 1
$SU_CMD update-mime-database "/usr/local/share/mime"
cp build/install_manifest.txt "$CUR_DIR/manifest/aeroshell-workspace_install_manifest.txt"
cd "$CUR_DIR/repos"

# Aeroshell KWin
git clone https://github.com/aeroshell-desktop/aeroshell-kwin-components.git aeroshell-kwin-components
cd aeroshell-kwin-components
git pull
cmake -DCMAKE_INSTALL_PREFIX=/usr -DKWIN_BUILD_WAYLAND=ON -B build . || exit 1
cmake --build build || exit 1
$SU_CMD cmake --install build || exit 1
cp build/install_manifest.txt "$CUR_DIR/manifest/aeroshell-kwin-components_install_manifest.txt"
cd "$CUR_DIR/repos"

# Aeroshell SDDM KCM
git clone https://github.com/aeroshell-desktop/aeroshell-sddm-kcm.git aeroshell-sddm-kcm
cd aeroshell-sddm-kcm
git pull
cmake -DCMAKE_INSTALL_PREFIX=/usr -B build . || exit 1
cmake --build build || exit 1
$SU_CMD cmake --install build || exit 1
cp build/install_manifest.txt "$CUR_DIR/manifest/aeroshell-sddm-kcm_install_manifest.txt"
cd "$CUR_DIR/repos"

# Aerothemeplasma icons
git clone https://github.com/aeroshell-desktop/atp/aerothemeplasma-icons aerothemeplasma-icons
cd aerothemeplasma-icons
git pull
cmake -DCMAKE_INSTALL_PREFIX=/usr -B build . || exit 1
cmake --build build || exit 1
$SU_CMD cmake --install build || exit 1
cp build/install_manifest.txt "$CUR_DIR/manifest/icons_install_manifest.txt"
cd "$CUR_DIR/repos"

# Aerothemeplasma sounds
git clone https://github.com/aeroshell-desktop/atp/aerothemeplasma-sounds aerothemeplasma-sounds
cd aerothemeplasma-sounds
git pull
cmake -DCMAKE_INSTALL_PREFIX=/usr -B build . || exit 1
cmake --build build || exit 1
$SU_CMD cmake --install build || exit 1
cp build/install_manifest.txt "$CUR_DIR/manifest/sounds_install_manifest.txt"
cd "$CUR_DIR/repos"

# Aerothemeplasma
cd "$CUR_DIR"
cmake -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_INSTALL_LIBEXECDIR=$LIBEXEC_DIR -B build . || exit 1
cmake --build build || exit 1
$SU_CMD cmake --install build || exit 1
cp build/install_manifest.txt "$CUR_DIR/manifest/aerothemeplasma_install_manifest.txt"
cd "$CUR_DIR/repos"


echo "Done."


rm /usr/share/wayland-sessions/plasma.desktop

sed -i "s/#Current=01-breeze-fedora/Current=sddm-theme-mod/g" /etc/sddm.conf
sed -i "s/#CursorTheme=/CursorTheme=aero-drop/g" /etc/sddm.conf

dnf autoremove -y


systemctl disable plasmalogin.service
systemctl enable sddm.service