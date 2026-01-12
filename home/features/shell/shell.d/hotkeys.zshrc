# ---------------------------------------------------------
# 1. THE NUCLEAR RESET
# ---------------------------------------------------------
# Wipes all existing bindings. Terminal is "dead" after this 
# until the rest of the script executes.
bindkey -rp ""

# ---------------------------------------------------------
# 2. THE SAFETY NET (ASCII & Extended Range)
# ---------------------------------------------------------
# \x00-\x1F : Control Characters (Null to Unit Separator)
# \x20-\x7E : Printable Characters (Space to Tilde)
# \x7F      : DEL (Modern Backspace)
# \x80-\xFF : Extended ASCII / UTF-8 lead bytes
bindkey -R "\x00"-"\xFF" self-insert

# ---------------------------------------------------------
# 3. CORE TERMINAL CONTROLS
# ---------------------------------------------------------
bindkey '^M' accept-line            # [Enter] (Carriage Return / Ctrl+M)
bindkey '^J' accept-line            # [Line Feed] (Ctrl+J)
bindkey '^I' fzf-completion         # [Tab] (Horizontal Tab / Ctrl+I)
bindkey '^?' backward-delete-char   # [Backspace] (DEL / ASCII 127)
bindkey '^H' backward-delete-char   # [Ctrl + Backspace] (BS / ASCII 08)
bindkey '^L' clear-screen           # [Ctrl + L] (Form Feed)
bindkey '^V' quoted-insert          # [Ctrl + V] (Synchronous Idle)
bindkey '^Q' quoted-insert          # [Ctrl + Q] (XON - Resume Output)
bindkey '^@' autosuggest-accept     # [Ctrl + Space]

# ---------------------------------------------------------
# 4. EMACS-STYLE NAVIGATION & EDITING
# ---------------------------------------------------------
bindkey '^A' beginning-of-line      # [Ctrl + A]
bindkey '^E' end-of-line            # [Ctrl + E]
bindkey '^F' forward-char           # [Ctrl + F]
bindkey '^B' backward-char          # [Ctrl + B]
bindkey '^K' kill-line              # [Ctrl + K] (Cut to end)
bindkey '^U' kill-whole-line        # [Ctrl + U] (Cut whole line)
bindkey '^W' backward-kill-word     # [Ctrl + W] (Delete word)
bindkey '^Y' yank                   # [Ctrl + Y] (Paste/Yank)

# ---------------------------------------------------------
# 5. COMMAND HOTKEYS / FUNCTIONS
# ---------------------------------------------------------
bindkey '^R' fzf-history-widget     # [Ctrl + R] (Fuzzy History)
bindkey '^T' fzf-file-widget        # [Ctrl + T] (Fuzzy File Search)
bindkey '\ec' fzf-cd-widget         # [Alt + C] (Fuzzy CD)

# ---------------------------------------------------------
# 6. ARROW KEYS & HARDWARE SEQUENCES
# ---------------------------------------------------------
# Standard ANSI Sequences
bindkey '^[[A' up-line-or-history    # [Up Arrow]
bindkey '^[[B' down-line-or-history  # [Down Arrow]
bindkey '^[[C' forward-char          # [Right Arrow]
bindkey '^[[D' backward-char         # [Left Arrow]

# Application Mode Sequences (Used by some terminals like PuTTY/Screen)
bindkey '^[OA' up-line-or-history    # [Up Arrow] (App Mode)
bindkey '^[OB' down-line-or-history  # [Down Arrow] (App Mode)
bindkey '^[OC' forward-char          # [Right Arrow] (App Mode)
bindkey '^[OD' backward-char         # [Left Arrow] (App Mode)
bindkey '^[OH' beginning-of-line     # [Home]
bindkey '^[OF' end-of-line           # [End]

# Modifier Keys (Alt + Arrows / Ctrl + Arrows)
bindkey '^[[1;3C' forward-word       # [Alt + Right Arrow]
bindkey '^[[1;3D' backward-word      # [Alt + Left Arrow]
bindkey '^[[3~'   delete-char        # [Delete Key] (Fn + Backspace on Mac)

# ---------------------------------------------------------
# 7. TERMINAL PROTOCOLS
# ---------------------------------------------------------
# Bracketed Paste Mode: Prevents pasted text from being 
# interpreted as immediate commands.
bindkey '^[[200~' bracketed-paste    # [Automatic sequence on Paste]