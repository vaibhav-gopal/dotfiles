#define completers to use
zstyle ':completion:*' completer _complete _approximate _extensions
#sort by modification time
zstyle ':completion:*' file-sort modification
zstyle ':completion:*' list-dirs-first yes
zstyle ':completion:*' verbose yes
#allow case insensitive, and partial completions
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
#Completion Prompt (Formatting descriptions and correction completers)
zstyle ':completion:*' format '%F{green} -- Completing : %d --%f'
zstyle ':completion:*:*:*:*:descriptions' format '%F{green}-- %d --%f'
zstyle ':completion:*:*:*:*:corrections' format '%F{yellow}!- %d (errors: %e) -!%f'
zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'
#group different type of completions under different lists
zstyle ':completion:*' group-name ''
#allow for completing options as well
zstyle ':completion:*' complete-options true
#define order of groupings for completion
zstyle ':completion:*:*:-command-:*:*' group-order alias functions builtins commands
#list item formatting (use default colors)
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
#able to use arrow keys for menu
zstyle ':completion:*' menu select
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s

autoload -Uz compinit
compinit

#enable using the compgen and complete functions, which are written for bash
autoload -Uz bashcompinit
bashcompinit
