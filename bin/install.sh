#!/bin/bash
set -ev
echo "install.sh hello world!"

USE_GET_UNITY=true

# See https://unity3d.com/get-unity/download/archive to get download URLs
UNITY_DOWNLOAD_CACHE="${HOME}/unity_download_cache"

#Setup Default Values if ENV vars do not exist
if [ ! -z "${UNITY_INSTALLER_HASH}" ] && [ ! -z "${UNITY_VERSION}" ]; then

  UNITY_DOWNLOAD_URL="https://download.unity3d.com/download_unity/${UNITY_INSTALLER_HASH}/MacEditorInstaller/${UNITY_VERSION}.pkg"
  echo "Using download link specified by environment:" $UNITY_DOWNLOAD_URL

elif [ USE_GET_UNITY ]; then

  #Attempt to get a download link for the requested version out of json
  if [ ! -z "${UNITY_VERSION}" ]; then
    UNITY_DOWNLOAD_URL=$(get-unity $UNITY_VERSION)
  fi

  if [ -z "${UNITY_VERSION}" ]; then
    UNITY_DOWNLOAD_URL=$(get-unity)
  fi


  echo "cmd: get-unity" $UNITY_VERSION
  echo "installer-url:" $UNITY_DOWNLOAD_URL

  #grep out the exact unity version number we got back
  UNITY_VERSION=$(grep -o -E "[0-9]+\.[0-9]+\.[0-9]+[a-z][0-9]+" <<< $UNITY_DOWNLOAD_URL)
  echo "Version:" $UNITY_VERSION
  export UNITY_VERSION

else

  # All platofrm links but we only use Mac
  UNITY_MAC_VERSIONS_URL="https://public-cdn.cloud.unity3d.com/hub/prod/releases-darwin.json"
  #UNITY_WIN_VERSIONS_URL="https://public-cdn.cloud.unity3d.com/hub/prod/releases-win32.json"
  #UNITY_NIX_VERSIONS_URL="https://public-cdn.cloud.unity3d.com/hub/prod/releases-linux.json"

  #Download JSON data that UnityHub uses to get its urls
  VERSIONS_JSON=$(curl $UNITY_MAC_VERSIONS_URL)

  #AVAILABLE_VERSIONS=$(jq ".official | .[].version" <<< "${VERSIONS_JSON}")
  #echo "Available Versions:" $AVAILABLE_VERSIONS

  #Attempt to get a download link for the requested version out of json
  if [ ! -z "${UNITY_VERSION}" ]; then
    MY_VERSION_URL=$(jq ".official[] | select(.version | startswith(\""${UNITY_VERSION}"\")).downloadUrl" <<< "${VERSIONS_JSON}")
    MY_VERSION_URL=$(jq --slurp --raw-input 'split("\n")[:-1]' <<< "${MY_VERSION_URL}")
    UNITY_DOWNLOAD_URL=$(jq --raw-output ".[-1]" <<< "${MY_VERSION_URL}")
    echo "Using Download Url:" $UNITY_DOWNLOAD_URL
  fi

  #Fallback to the latest version of unity
  if [ -z "${UNITY_DOWNLOAD_URL}" ]; then
    #Latest version should be the last element in the array
    LATEST_VERSION_JSON=$(jq '.official[-1]' <<< "${VERSIONS_JSON}")
    LATEST_VERSION=$(jq '.version' <<< "${LATEST_VERSION_JSON}")
    UNITY_VERSION=$LATEST_VERSION_JSON
    UNITY_DOWNLOAD_URL=$(jq '.downloadUrl' <<< "${LATEST_VERSION_JSON}")
    echo "Downloading Latest Version:" $LATEST_VERSION
    echo "Download Url:" "${UNITY_DOWNLOAD_URL}"
  fi

  #Remove front and back quotes from URL we just parsed out of JSON
  UNITY_DOWNLOAD_URL="${UNITY_DOWNLOAD_URL%\"}"
  UNITY_DOWNLOAD_URL="${UNITY_DOWNLOAD_URL#\"}"
  export UNITY_VERSION

fi

# Create our cache directory if it does not exist
if [ ! -d $UNITY_DOWNLOAD_CACHE ]; then
  mkdir -m 777 $UNITY_DOWNLOAD_CACHE
fi

#Get name of installer file from the URL
FILENAME=$(basename "${UNITY_DOWNLOAD_URL}")
INSTALLER_PATH="${UNITY_DOWNLOAD_CACHE}/${FILENAME}"

# Downloads a package if it does not already exist in cache
if [ ! -e $INSTALLER_PATH ]; then
	echo "Downloading installer."
	curl -o "${INSTALLER_PATH}" ${UNITY_DOWNLOAD_URL}
else
	echo "${FILENAME} Exists. Skipping download."
fi

echo "Installing Unity"
sudo installer -dumplog -package "${INSTALLER_PATH}" -target /
