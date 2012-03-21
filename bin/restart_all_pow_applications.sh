#!/bin/bash

cd $HOME/.pow
find . -type l -exec touch "`pwd`/{}/tmp/restart.txt" \;
