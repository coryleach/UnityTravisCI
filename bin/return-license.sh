#!/bin/bash

# https://github.com/tmux/tmux/issues/475#issuecomment-231527324
export EVENT_NOKQUEUE=1

echo "Returning Unity License"

if [ -z "${UNITY_APP}" ]; then
  echo "UNITY_APP environment variable not set. It should be set to the Unity install path"
  exit 1
fi

#Return Unity License
"${UNITY_APP}/Contents/MacOS/Unity" \
-batchmode \
-nographics \
-returnlicense \
-quit || exit 1
