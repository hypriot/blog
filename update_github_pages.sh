#!/bin/bash

cd ./public

git init
git config user.name "Hugo Builder"
git config user.email "hugo.builder@hypriot.com"
git remote add upstream "https://${GITHUB_TOKEN}@github.com/hypriot/hypriot.github.io.git"
git fetch upstream
git reset upstream/master

git add -A .
git commit -m "CircleCi build #${CIRCLE_BUILD_NUM} with git commit ${CIRCLE_SHA1}"
git remote show upstream
git push -q upstream HEAD:master
