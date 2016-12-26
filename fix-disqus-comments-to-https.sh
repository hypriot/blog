#!/bin/bash
if [ "$1" == "" ]; then
  echo 1. Open https://hypriot.disqus.com/admin/discussions/migrate/ and start the URL mapper.
  echo 2. Download CSV and run this script with it.
  echo 3. Upload new CSV to migrate all links to https.
  exit 1
fi

input=$1
output=${input//.csv/-upload.csv}
rm -f "$output"
echo "Fixing CSV $input -> $output"
while read -r link; do
   link=${link///}
   httpslink=${link//\?*/}
   httpslink=${httpslink//http:/https:}
   echo "$link,$httpslink" >> "$output"
done <"$input"
