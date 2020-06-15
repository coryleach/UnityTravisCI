#!/bin/bash

# https://github.com/tmux/tmux/issues/475#issuecomment-231527324
export EVENT_NOKQUEUE=1

echo "Authorizing Unity ${UNITY_VERSION}"

if [ -z "${UNITY_APP}" ]; then
  echo "UNITY_APP environment variable not set. It should be set to the Unity install path"
fi

if [[ -z "${UNITY_USERNAME}" ]] || [[ -z "${UNITY_PASSWORD}" ]]; then
  echo "UNITY_USERNAME or UNITY_PASSWORD environmnet variables are not set."
  exit 1
fi

if [ ! -z "${UNITY_SERIAL}" ]; then

  "${UNITY_APP}/Contents/MacOS/Unity" \
  -logfile - \
  -serial "${UNITY_SERIAL}" \
  -username "${UNITY_USERNAME}" \
  -password "${UNITY_PASSWORD}" \
  -batchmode \
  -nographics \
  -quit || exit 1

else

  echo "Authorizing Unity without a Serial key is not currently supported."
  exit 1

fi
