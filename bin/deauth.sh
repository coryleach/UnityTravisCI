#!/bin/bash

# https://github.com/tmux/tmux/issues/475#issuecomment-231527324
export EVENT_NOKQUEUE=1

echo "Deauthorizing Unity"

#Authorize unity with serial if we have one
"${UNITY_APP}/Contents/MacOS/Unity" \
-quit \
-returnlicense
