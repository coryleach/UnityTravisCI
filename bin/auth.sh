#!/bin/bash

echo "Looking for Unity..."
UNITY_INSTALLS=$(find /Applications/Unity -name "Unity.app")
UNITY_APP=$(grep "${UNITY_VERSION}" <<< "$UNITY_INSTALLS")
echo "found:" $UNITY_APP
export UNITY_APP

echo "Authorizing Unity ${UNITY_VERSION}"

if [ ! -z "${UNITY_SERIAL}" ]; then
  #Authorize unity with serial if we have one
  "${UNITY_APP}/Contents/MacOS/Unity" \
  -quit \
  -batchmode \
  -serial "${UNITY_SERIAL}" \
  -username "${UNITY_USERNAME}"
  -password "${UNITY_PASSWORD}"
fi
