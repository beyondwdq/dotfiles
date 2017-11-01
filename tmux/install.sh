#!/usr/bin/env bash

srcdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

ln -sf $srcdir/.tmux.conf $HOME/
