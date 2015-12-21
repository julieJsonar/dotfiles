#!/bin/bash
BEGIN {
    FS=":|;";
    OFS=""
}

# the 1st file: main file
NR==FNR {
    last_f2 = $2;
    #sub(/^[ \t]+/, "",$0)
    split($0, a, ";")
    cmds[(a[2])];
    print $0;
}

# the 2nd file: changed file
NR!=FNR {
    split($0, a, ";")
    if ((a[2]) in cmds == 0) {
        last_f2 = last_f2 + 1;
        sub(/: [0-9]+/, ": "last_f2, $0)
        if (length($0) > 0) {
            print $0;
        }
    }
}

END {
}
