#!/bin/bash
set -e

PATH=node_modules/.bin/:$PATH

mkdir -p css js build/tmp

js_files='
   node_modules/jquery/dist/cdn/jquery-2.1.3.min.js
   node_modules/jquery-ui/core.js
   node_modules/jquery-ui/widget.js
   node_modules/jquery-ui/mouse.js
   node_modules/jquery-ui/position.js
   node_modules/jquery-ui/draggable.js
   node_modules/jquery-ui/resizable.js
   node_modules/jquery-ui/button.js
   node_modules/jquery-ui/slider.js
   node_modules/jquery-ui/dialog.js
   assets/js/hotkeys.js
   coffee/ttp-logic.coffee
'

us='' # names of compiled files
changed=0
for f in $js_files; do 
  u=build/tmp/${f//\//_} # replace / with _
  us="$us $u"
  if [ $f -nt $u ]; then
    changed=1
    if [ $f != ${f%%.coffee} ]; then echo "compiling $f"; coffee -bcp $f >$u
    elif [ $f != ${f%%.min.js} ]; then echo "copying $f"; cp $f $u 
    else echo "cleaning up $f"; <$f sed '/^\(var \w\+ = \)\?require(/d' >$u; fi 
  fi 
done
if [ $changed -eq 1 ]; then echo 'concatenating libs'; cat $us >js/ttp-logic.js; fi 

node-sass -o css sass/*.sass

