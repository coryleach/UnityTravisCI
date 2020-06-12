#!/bin/bash

echo "Before Installing"
ls

#install JQ for parsing json list of unity versions
brew install jq
brew install node
npm install -g get-unity
