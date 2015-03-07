#!/bin/bash
set -e

PATH=node_modules/.bin/:$PATH

mkdir -p css js

coffee -o js coffee/*.coffee
node-sass -o css sass/*.sass
