#!/usr/bin/env bash

set -o vi
# Disable Software Control Flow (Ctrl-s locks screen)
stty -ixon

if hash apt-get 2>/dev/null; then
	alias agi='apt-get install'
	alias acs='apt-cache search'
fi

if hash tmux 2>/dev/null; then
	#https://superuser.com/questions/399296/256-color-support-for-vim-background-in-tmux
	alias tmux='tmux -2'  # for 256color
fi

if hash ack-grep 2>/dev/null; then
	alias ack='ack-grep'
fi

if hash vimx 2>/dev/null; then
	alias vi='vimx'
	alias vim='vimx'
fi
