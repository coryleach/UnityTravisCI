#!/bin/bash

# https://github.com/tmux/tmux/issues/475#issuecomment-231527324
export EVENT_NOKQUEUE=1

echo "Deauthorizing Unity"

#Return Unity License
"${UNITY_APP}/Contents/MacOS/Unity" \
-logFile "./unity.returnlicense.log" \
-batchmode \
-returnlicense \
-quit
