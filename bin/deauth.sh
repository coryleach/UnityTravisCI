#!/bin/bash

echo "Deauthorizing Unity"

if [ ! -z "${UNITY_SERIAL}" ]; then
  #Authorize unity with serial if we have one
  "${UNITY_APP}/Contents/MacOS/Unity" \
  -quit \
  -returnlicense
fi
