#!/usr/bin/env bash

srcdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "Fetching tmux plugin manager"
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
echo "Linking config"
ln -sf $srcdir/.tmux.conf $HOME/
