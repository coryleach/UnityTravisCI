#!/bin/bash

echo "Getting path to Unity.app..."
UNITY_INSTALLS=$(find /Applications/Unity -name "Unity.app")
UNITY_INSTALL_LAST=$(head -1 <<< "${UNITY_INSTALLS}")

echo $UNITY_INSTALLS

if [ ! -z "${UNITY_VERSION}" ]; then
  UNITY_APP_MATCHED=$(grep "${UNITY_VERSION}" <<< "$UNITY_INSTALLS")
fi

UNITY_APP=${UNITY_APP_MATCHED:-$UNITY_INSTALL_LAST}

if [ -z "${UNITY_APP}"]; then
  echo "Unity install not found."
  exit 1
else
  echo "found:" $UNITY_APP
  export UNITY_APP
fi
