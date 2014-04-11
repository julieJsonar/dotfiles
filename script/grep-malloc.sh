#!/bin/bash
# usage: xyz.sh "struct-name" 
name="$1"
grep -Enr -A10 --include="*.[ch]" -- "struct $name[ ]?\*\w*;" daemon/wad | grep -B10 "wad_mem_malloc" |grep "struct $name\|wad_mem_malloc"
