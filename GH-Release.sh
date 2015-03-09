#!/bin/bash
set -e

## build the latest for all platforms
./dist.sh osx linux win

# create JSON
BUILDDIR=build
PROJECT=`cat package.json | awk '/name/ {print $3}' | sed 's/\"//g;s/,//g'`
TMP_JSON=/tmp/GH-Publish.json
BASE_VERSION=`cat package.json | awk '/version/ {print $3}' | sed 's/\"//g;s/,//'`
VERSION="${BASE_VERSION}-`git rev-list HEAD --count`"

if [ -s GHTOKEN ]; then
  TOKEN="`cat GHTOKEN`"
else
  echo 'Please put your GitHub API Token in a file named "GHTOKEN"'
  exit 1
fi
cat >$TMP_JSON <<.
{
  "tag_name": "v$VERSION",
  "target_commitish": "master",
  "name": "v$VERSION",
  "body": $(
    ( echo -e 'Release of '${PROJECT}' V'${VERSION}'\n\nChangelog:'; git log --format='%s' $(git tag | tail -n 1).. ) \
      | grep -v -i todo | python -c 'import json,sys; print(json.dumps(sys.stdin.read()))'
  ),
  "draft": true,
  "prerelease": true
}
.

REPO=`git ls-remote --get-url origin | sed 's/.*github.com\://;s/.git$//'`
TMP_RESPONSE=/tmp/GH-Response.json
curl -o $TMP_RESPONSE --data @$TMP_JSON -H "Authorization: token $TOKEN" -i https://api.github.com/repos/$REPO/releases

RELEASE_ID=`grep '"id"' $TMP_RESPONSE | head -1 | sed 's/.*: //;s/,//'`

echo "created release with id: $RELEASE_ID"

for DIR in `ls ${BUILDDIR}/${PROJECT}`; do
  OS=`echo ${DIR} | sed 's/64//;s/32//'`
  BITS=`echo ${DIR} | sed 's/osx//;s/linux//;s/win//'`

  case ${OS} in
    osx)
      OSNAME="mac${BITS}"
      ;;
    win)
      OSNAME="windows${BITS}"
      ;;
    *)
      OSNAME="${OS}${BITS}"
      ;;
  esac

  ZIP=${PROJECT}-${VERSION}_${OSNAME}.zip
  TMP_ZIP=/tmp/$ZIP
  cd ${BUILDDIR}/${PROJECT}/$DIR
  echo "creating $TMP_ZIP"
  zip -q -r "$TMP_ZIP" .
  echo 'uploading to Github'
  curl -o /dev/null -H "Authorization: token $TOKEN" \
    -H 'Accept: application/vnd.github.manifold-preview' \
    -H 'Content-Type: application/zip' \
    --data-binary @"$TMP_ZIP" \
    https://uploads.github.com/repos/$REPO/releases/$RELEASE_ID/assets?name=$ZIP
  rm "$TMP_ZIP"
  cd -
done
rm $TMP_RESPONSE $TMP_JSON
