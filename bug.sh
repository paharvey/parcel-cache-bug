#!/bin/sh

echo
echo "Removing all caches"
rm -rf node_modules
rm -rf .parcel_cache
rm -rf dist

echo
echo "Installing dependencies"
npm install

echo
echo "Doing a first build, which should PASS"
npm exec parcel build

echo
echo "Breaking an import statement"
sed -i 's_lodash-es_./other.js_' src/main.js

echo
echo "Doing a second build, which should FAIL"
npm exec parcel build

echo
echo "Unbreaking the import"
sed -i 's_./other.js_lodash-es_' src/main.js

echo
echo "Doing a third build, which should PASS but will FAIL"
npm exec parcel build
