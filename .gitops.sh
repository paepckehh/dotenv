#!/bin/sh

action() {
        echo "### $XCMD"
        $XCMD
}

ROOT=$PWD
ls | while read item; do 
        TARGET=$ROOT/$item
        if [ -d $TARGET ]; then 
        cd $TARGET && {
                echo "############################################################"
                echo "### $TARGET"
                case $1 in
                fetch) XCMD="git fetch --all --force" && action && XCMD="git gc --auto" && action;;
                push) XCMD="git push" && action;;
                pull) XCMD="git pull --all --force" && action && XCMD="git gc --auto" && action;;
                compact) XCMD="git gc --aggressive" && action;;
                update) 
                        if [ -d .git ]; then
                          echo "### git repo mode"
                          XCMD="git fetch --all --force" && action && XCMD="git gc --auto" && action
                        else 
                          echo "### git worktree mode"
                          XCMD="git pull --all --force" && action && XCMD="git gc --auto" && action
                        fi 
                        ;;
                *) echo "Please choose one of the following actions: [update|compact|fetch|pull|push]"
                esac
        }
        fi
done
