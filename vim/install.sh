#!/usr/bin/env bash

srcdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

mkdir -p $HOME/.vim/bundle
ln -sf $srcdir/.vimrc $HOME/
ln -sf $srcdir/download.py $HOME/.vim/bundle/
ln -sf $srcdir/repos_urls.txt $HOME/.vim/bundle/
