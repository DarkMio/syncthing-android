#!/usr/bin/env bash

set -e

version=$(git describe --tags)
regex='^[0-9]+\.[0-9]+\.[0-9]+$'
if [[ ! ${version} =~ $regex ]]
then
    echo "Current commit is not a release"
    exit;
fi

echo "

Pushing to Github
-----------------------------
"
git push
git push --tags

version=`git describe --tags --abbrev=0`

echo "

Push to Google Play
-----------------------------
"

read -s -p "Enter signing password: " password

SIGNING_PASSWORD=${password} ./gradlew assembleRelease

# Upload apk and listing to Google Play
SIGNING_PASSWORD=${password} ./gradlew publishRelease

echo "

Release published!
"

#echo "
#
#Create Github Release
#-----------------------------
#"
#ACCESS_TOKEN=""
#api_json=$(printf '{"tag_name": "v%s","target_commitish": "master","name": "v%s","body": "%s","draft": false,"prerelease": false}' $version $version $changelog)
#curl --data "$api_json" https://api.github.com/repos/syncthing/syncthing-android/releases?access_token=$ACCESS_TOKEN
