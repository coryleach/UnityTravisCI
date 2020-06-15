#!/bin/bash

echo "Preparing to Install"

declare -a FILES=("install.sh"
                  "get-license.sh"
                  "run-tests.sh"
                  "return-license.sh"
                  "find-unity.sh"
                  "setup-project.sh"
                  "clean-project.sh")

#Download Files
for FILE in "${FILES[@]}"
do
   echo "Downlaoding ${FILE}"
   curl -fsSL "https://raw.githubusercontent.com/coryleach/UnityTravisCI/master/bin/${FILE}" > "./${FILE}"
   chmod +x "./${FILE}"
done

#install JQ for parsing json list of unity versions
brew install jq
brew install node
npm install -g get-unity
