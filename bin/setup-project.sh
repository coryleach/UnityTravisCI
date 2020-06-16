#!/bin/bash

echo "Creating project for package"

if [ -z "${UNITY_APP}" ]; then
  echo "UNITY_APP env var not defined. Cannot find installed Unity version."
  exit 1
fi

PACKAGE_FILE="$(pwd)/package.json"

if [ ! -f "$PACKAGE_FILE" ]; then

    echo "Project is not a package."

    if [ ! -z "${UNITY_PROJECT_FOLDER}" ]; then
      #If environment configured a project folder use that to set the path
      UNITY_PROJECT_PATH="$(pwd)/${UNITY_PROJECT_FOLDER}"
    else
      #If environment configuration not set then assume repo root is project root
      UNITY_PROJECT_PATH="$(pwd)"
    fi

    echo "Project Path: ${UNITY_PROJECT_PATH}"
    echo "If project path is incorrect make sure to correctly configure the UNITY_PROJECT_FOLDER environment variable"
    export UNITY_PROJECT_PATH

else

  UNITY_PROJECT_CACHE="${HOME}/project_cache"

  # Create our cache directory if it does not exist
  if [ ! -d $UNITY_PROJECT_CACHE ]; then
    mkdir -m 777 $UNITY_PROJECT_CACHE
  fi

  echo "Test target is a package"
  echo "Creating project for testing"
  UNITY_PROJECT_PATH="${UNITY_PROJECT_CACHE}/TestProject"
  export UNITY_PROJECT_PATH
  echo "Project Path: ${UNITY_PROJECT_PATH}"

  #Make sure that target directory is empty
  if [ -d $UNITY_PROJECT_PATH ]; then
    echo "Cleaning up old test project"
    rm -rf $UNITY_PROJECT_PATH
  fi

  #Create Project
  "${UNITY_APP}" \
      -batchmode \
      -nographics \
      -quit \
      -logFile - \
      -createProject "${UNITY_PROJECT_PATH}"  || exit 1

  #Modify packages to include our test package
  echo "Adding package name to manifest.json"
  MANIFEST_FILE="${UNITY_PROJECT_PATH}/Packages/manifest.json"
  if [ ! -f "${MANIFEST_FILE}" ]; then
    echo "Packages/manifest.json file not found in created project."
  fi

  PACKAGE_NAME=$(jq '.name' ${PACKAGE_FILE})
  echo 'Adding { '${PACKAGE_NAME}' : "file:'$(pwd)'" }'
  #Add Package Manifest Entry and write new manifest to temp file
  jq '.dependencies += { '${PACKAGE_NAME}' : "file:'$(pwd)'" } | .testables = ['${PACKAGE_NAME}']' ${MANIFEST_FILE} > temp.json || exit 1
  #Ovewrite old manifest with new manifest json
  mv temp.json ${MANIFEST_FILE}

fi
