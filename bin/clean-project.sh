#!/bin/bash

#if we created a test project we delete it here
UNITY_PROJECT_CACHE="${HOME}/project_cache"
PATH="${UNITY_PROJECT_CACHE}/TestProject"
if [ -d $PATH ]; then
  echo "Removing test project"
  rm -rf $PATH
fi
