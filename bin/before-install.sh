#!/bin/bash

echo "Before Installing"
ls

curl -fsSL https://raw.githubusercontent.com/coryleach/UnityTravisCI/master/bin/install.sh > ./install.sh
curl -fsSL https://raw.githubusercontent.com/coryleach/UnityTravisCI/master/bin/auth.sh > ./auth.sh
curl -fsSL https://raw.githubusercontent.com/coryleach/UnityTravisCI/master/bin/run-tests.sh > ./run-tests.sh
curl -fsSL https://raw.githubusercontent.com/coryleach/UnityTravisCI/master/bin/deauth.sh > ./deauth.sh

chmod +x ./install.sh
chmod +x ./auth.sh
chmod +x ./run-tests.sh
chmod +x ./deauth.sh

#install JQ for parsing json list of unity versions
brew install jq
brew install node
npm install -g get-unity
