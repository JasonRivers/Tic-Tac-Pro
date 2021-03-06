#!/bin/bash
set -e

npm install

./build.sh

node_version=0.11.4
b=build/nw-tmp
mkdir -p $b $b/assets
cp -R js css index.html $b
cp -R assets/sounds $b/assets
cp package.json $b

desktop_app() {
  echo "building for $@"
  node <<.
    var NWB = require('node-webkit-builder');
    var nwb = new NWB({
      files: '$b/**',
      version: '$node_version',
      platforms: '$@'.split(' ')
    });
    nwb.build().catch(function(e) {console.error(e); process.exit(1);});
.
}

desktop_app linux64

for bits in 32 64; do 
  d=cache/$node_version/linux$bits
  if [ -d $d -a ! -e $d/fixed-libudev ]; then
    echo "fixing node-webkit's libudev dependency for ${bits}-bit Linux"
    sed -i 's/udev\.so\.0/udev.so.1/g' $d/nw
    touch $d/fixed-libudev
    echo 'must rebuild the app...'
    desktop_app linux$bits # re-package the app after the libudev dependency has been fixed
  fi
done

