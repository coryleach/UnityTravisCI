#!/bin/bash

# https://github.com/tmux/tmux/issues/475#issuecomment-231527324
export EVENT_NOKQUEUE=1

if [[ -z "${UNITY_USERNAME}" ]] || [[ -z "${UNITY_PASSWORD}" ]]; then
  echo "UNITY_USERNAME or UNITY_PASSWORD environmnet variables are not set."
  exit 1
fi

echo "Looking for Unity..."
UNITY_INSTALLS=$(find /Applications/Unity -name "Unity.app")
UNITY_INSTALL_LAST=$(head -1 <<< "${UNITY_INSTALLS}")

echo $UNITY_INSTALLS

if [ ! -z "${UNITY_VERSION}" ]; then
  UNITY_APP_MATCHED=$(grep "${UNITY_VERSION}" <<< "$UNITY_INSTALLS")
fi

UNITY_APP=${UNITY_APP_MATCHED:-$UNITY_INSTALL_LAST}

echo "found:" $UNITY_APP
export UNITY_APP

echo "Authorizing Unity ${UNITY_VERSION}"

if [ ! -z "${UNITY_SERIAL}" ]; then

  "${UNITY_APP}/Contents/MacOS/Unity" \
  -logfile - \
  -serial "${UNITY_SERIAL}" \
  -username "${UNITY_USERNAME}" \
  -password "${UNITY_PASSWORD}" \
  -batchmode \
  -noUpm \
  -quit

else

  #Attempting Auth Without Serial (This currently isn't supported AFAIK)
  "${UNITY_APP}/Contents/MacOS/Unity" \
  -logfile - \
  -username "${UNITY_USERNAME}" \
  -password "${UNITY_PASSWORD}" \
  -batchmode \
  -noUpm \
  -quit

fi
