#!/bin/bash
set -e

coffee -o js coffee/*.coffee
sass -o css sass/*.sass
