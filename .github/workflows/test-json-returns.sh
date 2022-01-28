#!/bin/bash
find ../../. -type f -print0 | xargs -0 grep -w 'json:\"[A-Z]...'
if [ $? == 0 ]; then
  exit 1
else
  exit 0
fi
