#!/bin/bash
if [ "$DEFAULT_BROWSER" == "" ]
then
  DEFAULT_BROWSER='google-chrome --profile-directory=Default'
fi

$DEFAULT_BROWSER "$@"
