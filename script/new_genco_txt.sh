#!/bin/bash
#set -o nounset     # Treat unset variables as an error

ban_words=( \
  "WAD_RUN_TEST_FROM_CLI" \
  "daemon/wad/wad_debug.c" \
  "__FGT_DISK_MGR_DEBUG" \
  "wilson" \
  "message" \
  "cooked" \
)


rm -f patch.eco.diff 2> /dev/null
rm -f $HOME/.rb_genco/.rb_genco 2> /dev/null

if [ ! -f "rb_genco" ] ; then
    # new post
    rm -f rb_genco 2> /dev/null
    rb_genco.py diff -o patch.eco.diff
    rb_genco.py post
    cp $HOME/.rb_genco/.rb_genco rb_genco
    RB_ID="$(awk -F'=' '{print $2}' rb_genco)"
    echo "===================================================="
    echo "rb_genco.py post: create new ./rb_genco $RB_ID"
    echo "===================================================="
else
    # update existed id
    RB_ID="$(awk -F'=' '{print $2}' rb_genco)"
    rb_genco.py diff -o patch.eco.diff
    rb_genco.py update $RB_ID
    echo "===================================================="
    echo "rb_genco.py update ./rb_genco $RB_ID"
    echo "===================================================="
fi

if [ ! -f "rb_genco" ] ; then
    echo "Fail: local ./rb_genco file not exists"
fi

have_failed=0
for ban_word in "${ban_words[@]}"
do
    grep "$ban_word" patch.eco.diff
    if [ $? == 0 ]; then
        have_failed=1
        echo "Fail: patch contain bad words '$ban_word'!"
    fi
done

