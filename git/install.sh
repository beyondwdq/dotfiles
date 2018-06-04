#!/usr/bin/env bash

srcdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

ln -sf $srcdir/.gitconfig $HOME/
ln -sf $srcdir/.gitignore_global $HOME
