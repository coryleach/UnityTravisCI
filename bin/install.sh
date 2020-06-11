#!/bin/bash

echo "install.sh hello world!"

UNITY_MAC_VERSIONS_URL = "https://public-cdn.cloud.unity3d.com/hub/prod/releases-darwin.json"
UNITY_WIN_VERSIONS_URL = "https://public-cdn.cloud.unity3d.com/hub/prod/releases-win32.json"
UNITY_NIX_VERSIONS_URL = "https://public-cdn.cloud.unity3d.com/hub/prod/releases-linux.json"

#Setup Default Values if ENV vars do not exist
if [ -z "${UNITY_INSTALLER_HASH}" ]; then
    UNITY_INSTALLER_HASH="dcb72c2e9334"
fi

if [ -z "${UNITY_INSTALLER_VERSION}" ]; then
    UNITY_INSTALLER_VERSION="2019.3.15f1"
fi

JSON=$(curl $UNITY_MAC_VERSIONS_URL | jq '.official[-1]')
LATEST_VERSION=$(jq --jsonargs '[version]' "${JSON}")
LATEST_VERSION_URL=$(jq --jsonargs '[downloadUrl]' "${JSON}")

echo $LATEST_VERSION
echo $LATEST_VERSION_URL

# Links for posterity
# MacOS Versions Download Link
# https://public-cdn.cloud.unity3d.com/hub/prod/releases-darwin.json

# Windows Version Download Link
# https://public-cdn.cloud.unity3d.com/hub/prod/releases-win32.json

# Linux Versions Download Link
# https://public-cdn.cloud.unity3d.com/hub/prod/releases-linux.json

# See https://unity3d.com/get-unity/download/archive to get download URLs
UNITY_DOWNLOAD_CACHE="${HOME}/unity_download_cache"
UNITY_INSTALLER_URL="https://download.unity3d.com/download_unity/${UNITY_INSTALLER_HASH}/MacEditorInstaller/${UNITY_INSTALLER_VERSION}.pkg"

# Create our cache directory if it does not exist
if [ ! -d $UNITY_DOWNLOAD_CACHE ]; then
  mkdir -m 777 $UNITY_DOWNLOAD_CACHE
fi

#Get name of installer file from the URL
FILENAME=$(basename "${UNITY_INSTALLER_URL}")
INSTALLER_FULLPATH="${UNITY_DOWNLOAD_CACHE}/${FILENAME}"

# Downloads a package if it does not already exist in cache
if [ ! -e $INSTALLER_FULLPATH ]; then
	echo "${FILENAME} does not exist. Downloading from ${UNITY_INSTALLER_URL}: "
	curl -o "${INSTALLER_FULLPATH}" "$UNITY_INSTALLER_URL"
else
	echo "${FILENAME} Exists. Skipping download."
fi

echo "Contents of Unity Download Cache:"
ls $UNITY_DOWNLOAD_CACHE

echo "Installing Unity"
sudo installer -dumplog -package "${INSTALLER_FULLPATH}" -target /
