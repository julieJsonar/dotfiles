#!/bin/bash
awk '($1~/.*'$1'.*/ && $2=="function") {printf $4":"$3":"; for(i=5;i<=NF;i++){printf "%s ", $i}; printf "\n"}' tags.x > /tmp/vim.taglist

