# Dotfiles for WSL Ubuntu (Linux)

See for tutorial I used: https://www.atlassian.com/git/tutorials/dotfiles

Essence: .cfg is the "bare" git repository used to store my Dotfiles
In order to manipulate dot files repo use the command:
> `git --git-dir=$HOME/.cfg/ --work-tree=$HOME`
> Which should have already been aliased in your .bashrc and .zshrc

By using a bare git repo, we avoid setting up a global parent dotfiles repo which messes up other git repos in the home directory

The .gitignore file is very important as it contains all files that can and cannot be added to the repo...
> Update whenver you add new files that you want to track as it automatically ignores everything except certain directories and files

Additionally this .cfg-info directory (which this README should be located in) is important to store text files related to the dotfiles, as to not
clutter the home directory

To delete the respoitory: delete the .cfg at home directory, and delete the .gitignore file

See aptrequirements.txt for software requirements --> Gets updated every commit to the dotfile repo via a pre-commit hook (see .cfg/hooks/pre-commit)

Some apt packages were installed through a PPA repository so be aware, and install accordingly (also some packages were wgetpre-installed through the WSL setup, so also be aware of that)

Here is additional packages/software that is not installed via apt, and at least from what I can remember (through curl or wget, etc...):

miniconda3 --> python version manager
rustup --> rust toolchain manager
bun --> nodejs alternative
nvm --> nodejs version manager
starship --> zsh/bash prompt

You can check what was installed via curl or wget via (given that the bash_history file is long enough)-->
cat .bash_history | grep wget
cat .bash_history | grep curl
