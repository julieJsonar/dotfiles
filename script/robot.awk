#!/usr/bin/awk -f
BEGIN {
    exitState = 0
}
{
    if ($0 ~ /Exit suddenly reason:/) {
        exitState = 1
    }
    else {
        if ($0 ~ /Exit suddenly without teardown/) {
            exitState = 3
        }
        if ($0 ~ /PleaseExitSudden/) {
            exitState = 2
        }
    }

    if (exitState < 2) {
        print $0
    }
}
