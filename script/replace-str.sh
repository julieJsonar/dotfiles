#!/bin/bash - 
set -o nounset   # Treat unset variables as an error

# ag -G '\.[ch]$' -rl '\t\t_WAD_TRACE_;' | xargs sed -i 's/\t\t_WAD_TRACE_;/\t_WAD_TRACE_;/'
ag -G '\.[ch]$' -rl -w $1 | xargs sed -i 's/\<'$1'\>/'$2'/'
