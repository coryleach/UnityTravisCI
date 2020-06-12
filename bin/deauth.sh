#!/bin/bash

# https://github.com/tmux/tmux/issues/475#issuecomment-231527324
export EVENT_NOKQUEUE=1

echo "Deauthorizing Unity"

if [ ! -z "${UNITY_SERIAL}" ]; then
  #Authorize unity with serial if we have one
  "${UNITY_APP}/Contents/MacOS/Unity" \
  -quit \
  -returnlicense
fi
