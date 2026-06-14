#!/usr/bin/env bash

set -ouex pipefail


IMAGE_NAME="plasmosis"
IMAGE_PRETTY_NAME="Neoplasmosis"
VERSION_ID=$(grep -Po '(?<=^VERSION_ID=).*' /usr/lib/os-release | tr -d '"')
HOME_URL="https://github.com/Sylvie00/plasmosis"

sed -i "s/^PRETTY_NAME=.*/PRETTY_NAME=\"${IMAGE_PRETTY_NAME} ${VERSION_ID}\"/" /usr/lib/os-release
sed -i "s/^NAME=.*/NAME=\"$IMAGE_PRETTY_NAME\"/" /usr/lib/os-release
sed -i "s/^ID=fedora/ID=${IMAGE_NAME}/" /usr/lib/os-release
sed -i "s/^ID_LIKE=.*/ID_LIKE=\"fedora\"/" /usr/lib/os-release
sed -i "s|^HOME_URL=.*|HOME_URL=\"$HOME_URL\"|" /usr/lib/os-release
sed -i "s/^DEFAULT_HOSTNAME=.*/DEFAULT_HOSTNAME=\"${IMAGE_PRETTY_NAME,,}\"/" /usr/lib/os-release