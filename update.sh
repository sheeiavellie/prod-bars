#!/usr/bin/env bash

IFS='
'
export $(egrep -v '^#' .env | xargs -0)
IFS=
prodDir=$PWD
branch=$@
if [  -z "$@" ]
  then
    if [  -z "$PROJECTS_BRANCH" ]
      then
        branch=release
      else
        branch=$PROJECTS_BRANCH
      fi
fi
echo "Working branch " $branch

folders=(\
    $API_BARS_SRC_DIR \
      )

for folder in ${folders[*]}
do
    echo "update " $folder
    cd $folder && git fetch
    cd $folder && git reset --hard origin/$branch
done

cd $prodDir && docker-compose up -d --build