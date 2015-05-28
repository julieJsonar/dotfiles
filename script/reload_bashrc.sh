#!/bin/sh
#!/bin/bash

currentPane=$(tmux list-panes | grep "(active)" | awk '{print $1}' | cut -f 1 -d:)
finalPaneThisWindow=$(tmux list-panes | tail -1 | awk '{print $1}' | cut -f 1 -d:)
i=0
while [[ $i -le $finalPaneThisWindow ]] ; do
    tmux select-pane $i
    sleep 0.5   
    windowName=$(tmux display -p '#W')   
    if [[ $windowName == "$(basename $SHELL)" ]] ; then
       # remember to send cntrl-a and cntrl-k to delete the prompt first
        tmux send-keys "^a" "^u" "source ~/.zshrc" "Enter"
    fi

    let i++
done
