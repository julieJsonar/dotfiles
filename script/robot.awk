#!/usr/bin/awk -f
BEGIN {
    exitState = 0
    stopState = 0
    if (ARGC > 1) {
        stopCase = ARGV[1]
    }
}
{
    if (exitState == 0 && $0 ~ /#Exit suddenly start#/) {
        print "robot.awk debug: change state from ", exitState, " to 1: exit start";
        exitState = 1
        next
    }
    if (exitState == 1 && $0 ~ /\| FAIL \|/) {
        next
    }
    if (exitState == 1 && $0 ~ /etup failed:/) {
        next
    }
    if (exitState == 1 && $0 ~ /eardown failed:/) {
        next
    }
    if (exitState >= 2) {
        next
    }
    if ($0 ~ /ArExitSudden:/) {
        print "robot.awk debug: change state from ", exitState, " to 2, skip all follower";
        exitState = 2
        print $0
        next
    }

    if (ARGC > 1) {
        if ($0 ~ /stopCase/) {
            stopState = 1
        }
    }
    if (stopState == 1 && $0 ~ /--------/) {
        exitState = 2
        print $0
        next
    }
    if (stopState == 1 && $0 ~ /========/) {
        exitState = 2
        print $0
    }

    if (exitState < 2) {
        print $0
    }
}
