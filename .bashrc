# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

BASHDIR="$HOME/.config/bash"

if [ -d "$BASHDIR" ] ; then
	. "$BASHDIR/aliasesFunctions"
	. "$BASHDIR/generalConfig"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/vaibhav/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/vaibhav/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/vaibhav/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/vaibhav/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# Use starship prompt for interactive bash environments
eval "$(starship init bash)"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH=$BUN_INSTALL/bin:$PATH

# enable node version manager
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
