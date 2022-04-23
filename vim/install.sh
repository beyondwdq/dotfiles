#!/usr/bin/env bash

srcdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

mkdir -p ~/.vim/autoload ~/.vim/bundle
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

ln -sf $srcdir/.vimrc $HOME/
ln -sf $srcdir/download.py $HOME/.vim/bundle/
ln -sf $srcdir/repos_urls.txt $HOME/.vim/bundle/
