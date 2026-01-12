# ---------------------------------------------------------
# 1. INITIALIZATION & TIMING
# ---------------------------------------------------------
# Set Escape-key delay to 10ms (makes mode switching instant)
export KEYTIMEOUT=1

# Enable Vi Mode
bindkey -v

# ---------------------------------------------------------
# 2. THE NUCLEAR RESET
# ---------------------------------------------------------
# Clear the primary Insert and Command maps
bindkey -rp "" -M viins
bindkey -rp "" -M vicmd

# ---------------------------------------------------------
# 3. THE SAFETY NET (Full ASCII/Extended Range)
# ---------------------------------------------------------
# Map every possible 8-bit byte to self-insert in Insert Mode.
# This ensures that 'a'-'z', '0'-'9', and symbols always type.
bindkey -R -M viins "\x00"-"\xFF" self-insert

# Map Command Mode to 'undefined' so unused keys don't ghost-type
bindkey -R -M vicmd "\x00"-"\xFF" undefined-key

# ---------------------------------------------------------
# 4. INSERT MODE OVERRIDES (The "While Typing" Keys)
# ---------------------------------------------------------
# Core Controls
bindkey -M viins '^[' vi-cmd-mode            # [ESC] Switch to Command Mode
bindkey -M viins '^M' accept-line            # [Enter] (Hex 0D)
bindkey -M viins '^J' accept-line            # [Newline] (Hex 0A)
bindkey -M viins '^?' backward-delete-char   # [Backspace] (Hex 7F)
bindkey -M viins '^H' backward-delete-char   # [Ctrl+H / Backspace]
bindkey -M viins '^I' fzf-completion         # [Tab] (fzf trigger)

# Plugins (Autosuggest & FZF)
bindkey -M viins '^@' autosuggest-accept     # [Ctrl+Space] (NUL)
bindkey -M viins '^R' fzf-history-widget     # [Ctrl+R]
bindkey -M viins '^T' fzf-file-widget        # [Ctrl+T]
bindkey -M vicmd '\ec'  fzf-cd-widget        # [Alt+C] Change directory (fzf)

# Navigation (Standard Emacs style also available in Insert mode)
bindkey -M viins '^A' beginning-of-line      # [Ctrl+A]
bindkey -M viins '^E' end-of-line            # [Ctrl+E]
bindkey -M viins '^W' backward-kill-word     # [Ctrl+W]

# ---------------------------------------------------------
# 5. COMMAND MODE (Vim Navigation)
# ---------------------------------------------------------
# These only work after pressing [ESC]
bindkey -M vicmd 'h' vi-backward-char
bindkey -M vicmd 'j' down-line-or-history
bindkey -M vicmd 'k' up-line-or-history
bindkey -M vicmd 'l' vi-forward-char
bindkey -M vicmd 'w' vi-forward-word
bindkey -M vicmd 'e' vi-forward-word-end
bindkey -M vicmd 'b' vi-backward-word
bindkey -M vicmd '0' vi-beginning-of-line
bindkey -M vicmd '_' vi-end-of-line
bindkey -M vicmd '^[' vi-insert              # [ESC] Enter Insert Mode
bindkey -M vicmd ' ' vi-insert               # [Space] Enter Insert Mode
bindkey -M vicmd 'i' vi-insert               # [i] Enter Insert Mode
bindkey -M vicmd 'a' vi-add-next             # [a] Append
bindkey -M vicmd 'u' undo                    # [u] Undo
bindkey -M vicmd 'x' vi-delete-char          # [x] Delete char
bindkey -M vicmd 'd' vi-delete               # [d] Delete operator
bindkey -M vicmd 'c' clear-screen            # [c] Clear screen
bindkey -M vicmd 'v' quoted-insert           # [v] Verbatim input

# ---------------------------------------------------------
# 6. ARROW KEYS (Consistent across both modes)
# ---------------------------------------------------------
foreach map (viins vicmd)
  bindkey -M $map '^[[A' up-line-or-history     # [Up]
  bindkey -M $map '^[[B' down-line-or-history   # [Down]
  bindkey -M $map '^[[C' forward-char           # [Right]
  bindkey -M $map '^[[D' backward-char          # [Left]
  
  # Standard App Mode sequences
  bindkey -M $map '^[OA' up-line-or-history
  bindkey -M $map '^[OB' down-line-or-history
  bindkey -M $map '^[OC' forward-char
  bindkey -M $map '^[OD' backward-char
  
  # Delete key
  bindkey -M $map '^[[3~' delete-char           # [Delete]
end

# ---------------------------------------------------------
# 7. TERMINAL PROTOCOLS
# ---------------------------------------------------------
bindkey -M viins '^[[200~' bracketed-paste