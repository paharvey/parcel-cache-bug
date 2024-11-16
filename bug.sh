#!/bin/sh

echo
echo "Removing all caches"
echo
rm -rf node_modules
rm -rf .parcel-cache
rm -rf dist
echo
echo "Installing dependencies"
echo
npm install

echo
echo "-------------------------------------------------"
echo
echo "Doing build #1, which should PASS because the code is correct"
echo

npm exec parcel build

echo
echo "-------------------------------------------------"
echo
echo "Breaking an import statement"
sed -i 's_lodash-es_./other.js_' src/main.js
echo "Doing build #2, which should FAIL because the code is incorrect"
echo

npm exec parcel build

echo
echo "-------------------------------------------------"
echo
echo "Unbreaking the import"
sed -i 's_./other.js_lodash-es_' src/main.js
echo "Doing build #3, which should PASS because the code is correct"
echo

npm exec parcel build

echo
echo "-------------------------------------------------"
echo
echo "Breaking an import statement"
sed -i 's_lodash-es_./other.js_' src/main.js
echo "Doing build #4, which should FAIL because the code is incorrect"
echo

npm exec parcel build

echo
echo "-------------------------------------------------"
echo
echo "Unbreaking the import"
sed -i 's_./other.js_lodash-es_' src/main.js
echo "Doing build #5, which should PASS but will FAIL"
echo

npm exec parcel build
