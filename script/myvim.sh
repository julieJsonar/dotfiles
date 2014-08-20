#!/bin/bash
cd ~/.vim; for submodule in `git submodule | grep -v core | awk '{print $2}'`; do
    echo "call janus#disable_plugin('`basename ${submodule}`')" >> ~/.vimrc.before;
done
