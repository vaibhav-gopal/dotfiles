# ---------------------------------------------------------
# 1. INITIALIZATION & VI-MODE
# ---------------------------------------------------------
export KEYTIMEOUT=1         # Instant mode switching
bindkey -v                  # Enable Vi Mode logic

# ---------------------------------------------------------
# 2. THE NUCLEAR RESET
# ---------------------------------------------------------
bindkey -rp "" -M viins     # Clear Insert Map
bindkey -rp "" -M vicmd     # Clear Command Map

# ---------------------------------------------------------
# 3. THE SAFETY NET (Full ASCII/Extended Range)
# ---------------------------------------------------------
# Map everything to type characters by default in Insert Mode
bindkey -R -M viins "\x00"-"\xFF" self-insert

# Command Mode defaults to undefined to prevent ghost-typing
bindkey -R -M vicmd "\x00"-"\xFF" undefined-key

# ---------------------------------------------------------
# 4. INSERT MODE: EMACS CORE + PLUGINS + NAV
# ---------------------------------------------------------
# Transition to Vi-Command Mode
bindkey -M viins '^V' vi-cmd-mode            # [Ctrl+V]

# Standard Shell Controls
bindkey -M viins '^M' accept-line            # [Enter]
bindkey -M viins '^J' accept-line            # [Newline]
bindkey -M viins '^?' backward-delete-char   # [Backspace]
bindkey -M viins '^H' backward-delete-char   # [Ctrl+H / Delete]
bindkey -M viins '^L' clear-screen           # [Ctrl+L]
bindkey -M viins '^Q' quoted-insert          # [Ctrl+Q]

# Emacs-style Navigation (Available while typing)
bindkey -M viins '^A' beginning-of-line      # [Ctrl+A] Move to Start
bindkey -M viins '^E' end-of-line            # [Ctrl+E] Move to End
bindkey -M viins '^F' forward-char           # [Ctrl+F] Move Right
bindkey -M viins '^B' backward-char          # [Ctrl+B] Move Left

# Emacs-style Editing
bindkey -M viins '^K' kill-line              # [Ctrl+K] Delete to End
bindkey -M viins '^U' kill-whole-line        # [Ctrl+U] Delete Line
bindkey -M viins '^W' backward-kill-word     # [Ctrl+W] Delete Word
bindkey -M viins '^Y' yank                   # [Ctrl+Y] Paste Deleted

# Plugins
bindkey -M viins '^R' fzf-history-widget     # [Ctrl+R] Fuzzy History
bindkey -M viins '^T' fzf-file-widget        # [Ctrl+T] Fuzzy Files
bindkey -M viins '^I' fzf-completion         # [Tab] Fuzzy Completion
bindkey -M viins '^@' autosuggest-accept     # [Ctrl+Space] Accept Suggestion

# ---------------------------------------------------------
# 5. COMMAND MODE: VIM EDITING POWERS
# ---------------------------------------------------------
# Entry/Exit
bindkey -M vicmd ' ' vi-insert               # [Space] Return to Typing
bindkey -M vicmd '^[' vi-insert              # [Esc] Return to Typing
bindkey -M vicmd 'i' vi-insert               # [i] Insert
bindkey -M vicmd 'a' vi-add-next             # [a] Append

# Basic Movement (hjkl)
bindkey -M vicmd 'h' vi-backward-char
bindkey -M vicmd 'j' down-line-or-history
bindkey -M vicmd 'k' up-line-or-history
bindkey -M vicmd 'l' vi-forward-char

# Word Movements
bindkey -M vicmd 'w' vi-forward-word         # Next Word Start
bindkey -M vicmd 'b' vi-backward-word        # Prev Word Start
bindkey -M vicmd 'e' vi-forward-word-end     # Current Word End

# Line Movements
bindkey -M vicmd '0' vi-beginning-of-line    # [0] Start of Line
bindkey -M vicmd '$' vi-end-of-line          # [$] End of Line

# Editing Powers
bindkey -M vicmd 'u' undo                    # [u] Undo
bindkey -M vicmd 'x' vi-delete-char          # [x] Delete Char
bindkey -M vicmd 'd' vi-delete               # [d] Delete Operator (e.g. dw, dd)
bindkey -M vicmd 'v' visual-mode             # [v] Visual Select

# ---------------------------------------------------------
# 6. SHARED MAPPINGS (Arrows & Protocols)
# ---------------------------------------------------------
foreach map (viins vicmd)
  # Standard Arrows
  bindkey -M $map '^[[A' up-line-or-history
  bindkey -M $map '^[[B' down-line-or-history
  bindkey -M $map '^[[C' forward-char
  bindkey -M $map '^[[D' backward-char
  bindkey -M $map '^[OA' up-line-or-history
  bindkey -M $map '^[OB' down-line-or-history
  bindkey -M $map '^[OC' forward-char
  bindkey -M $map '^[OD' backward-char

  # Word Arrows (Ctrl+Arrows)
  bindkey -M $map '^[[1;5C' forward-word
  bindkey -M $map '^[[1;5D' backward-word
end

# Bracketed Paste
bindkey -M viins '^[[200~' bracketed-paste