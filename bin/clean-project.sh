#!/bin/bash

#if we created a test project we delete it here
PATH="${HOME}/TestProject"
if [ -f $PATH ]; then
  echo "Removing test project"
  rm -rf $PATH
fi
