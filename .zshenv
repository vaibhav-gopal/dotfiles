#!/bin/zsh

if [ ! -d "$HOME/.config/zsh" ] ; then
	echo "Please create a zsh directory in .config, and add appropriate files. "
	echo "See .zshenv and .zshrc"
fi


ZDIR=$HOME/.config/zsh

. $ZDIR/pathUpdate
