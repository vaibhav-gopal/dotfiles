" See this website for all the help you need
" https://neovim.io/doc/user/index.html
" All you need to use this config file is to download neovim and download
" vim-plug

" ==================== Editor behavior ====================
set t_Co=256
set history=500
set noshowmode
set laststatus=2
set showcmd
set magic
set so=7
set noerrorbells
set mouse=a 
set wildmode=longest,list
set wildmenu 
set incsearch
set hlsearch
set showmatch
set autochdir
set exrc
set number relativenumber
set cursorline
set noexpandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2
set autoindent
set list
set listchars=tab:\|\ ,trail:▫
set nottimeout
set timeoutlen=300
set viewoptions=cursor,folds
set splitright
set splitbelow
set signcolumn=yes
set ignorecase
set smartcase
set shortmess+=c
set shortmess+=s
set completeopt=menuone,noinsert
set backupdir=$HOME/.config/nvim/tmp/backup,.
set directory=$HOME/.config/nvim/tmp/backup,.
if has('persistent_undo')
	set undofile
	set undodir=$HOME/.config/nvim/tmp/undo,.
endif
set updatetime=100
set virtualedit=block
set termguicolors

let g:clipboard = {
  \   'name': 'WslClipboard',
  \   'copy': {
  \      '+': 'clip.exe',
  \      '*': 'clip.exe',
  \    },
  \   'paste': {
  \      '+': 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
  \      '*': 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
  \   },
  \   'cache_enabled': 0,
  \ }

" Return to last edit position when opening files (You want this!)
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

let g:neoterm_autoscroll = 1

" Set to auto read when a file is changed from the outside
set autoread
au FocusGained,BufEnter * checktime

" Enable filetype plugins
filetype plugin indent on

" ==================== Basic Mappings ====================

" For the <M- mappings, this means meta, in order to use meta in the terminal for mac
" You will have to go into teriminal settings and rebind either the left or right option key to meta

" Use default mapping of \ for leader key (2 backslashes b/c we need to escape the backslash)
let mapleader = "\\"

" Open the vimrc file anytime
nnoremap <LEADER>rc :e $HOME/.config/nvim/init.vim<CR>

" Disable highlight when <leader><cr> is pressed
noremap <silent> <leader><cr> :noh<cr>

" Fast saving
noremap <leader>ww <cmd>w!<cr>
inoremap <leader>ww <cmd>w!<cr>
vnoremap <leader>ww <cmd>w!<cr>

" Fast quitting with saving
noremap <leader>wq <cmd>wq!<cr>
inoremap <leader>wq <cmd>wq!<cr>
vnoremap <leader>wq <cmd>wq!<cr>

" Fast quitting with saving (buffers)
noremap <leader>wb <cmd>w!<cr><cmd>bd<cr>
inoremap <leader>wb <cmd>w!<cr><cmd>bd<cr>
vnoremap <leader>wb <cmd>w!<cr><cmd>bd<cr>

" Quitting without saving
noremap <leader>qq <cmd>q!<cr>
inoremap <leader>qq <cmd>q!<cr>
vnoremap <leader>qq <cmd>q!<cr>

" Quitting buffer
noremap <leader>qb <cmd>bd!<cr>
inoremap <leader>qb <cmd>bd!<cr>
vnoremap <leader>qb <cmd>bd!<cr>

" Open New Tab
noremap <leader>t <cmd>tabnew<cr>
inoremap <leader>t <cmd>tabnew<cr>
vnoremap <leader>t <cmd>tabnew<cr>

" move to first non-blank character 
noremap 0 ^

" macro executer key
noremap , @

" remap escape in insert, replace, visual and select mode
inoremap ii <esc>
vnoremap iu <esc>
cnoremap iu <esc>
onoremap iu <esc>
inoremap iu <esc>A

" insert/append a single character
nnoremap - <Esc>i_<Esc>r
nnoremap _ <Esc>a_<Esc>r
" insert newline at start of line
nnoremap <S-CR> I<CR><Esc>

" copy word under cursor
nnoremap <CR> yiw

" paste yank buffer (not just any delete or change operator)
noremap @ "0p

" move forward and backward half a page
noremap <Tab> <C-d>
noremap <S-Tab> <C-u>

" move/replace to last non-whitespace character in line 
nnoremap ; g_a_<Esc>r
vnoremap ; g_
onoremap ; g_
" change/delete word under cursor --> use autocmd b/c s character is a builtin synonym which we can't map
autocmd BufEnter * nnoremap s <Esc>ciw
" Replace last searched item with last yanked text
autocmd BufEnter * nnoremap S <Esc>gn"0p
" Delete character at the beginning of the line --> faster than unindenting (<<) --> remember X is delete before cursor
" Enter visual mode so we can use the special mark register for last visual selection
nnoremap <BS> vI<BS><Esc>`<
" delete line --> simple command but used often, faster than spamming dd
noremap <S-BS> dd

" cycle between find matches of the word using * and # --> automapped by nvim
" J --> append line below to current line --> automapped by nvim --> different from <BS> b/c it creates spaces
" also & repeats the last substitute using the substitute command (:s <pattern>) --> but make it better
" also g& replaces all text at once
nnoremap & <cmd>&&<cr><Esc>n

" REALLY IMPORTANT MOTION -> <operator1>i<operator2>
" i in a operator setting basically means "inside" then you can use w to select word, b for round brackets, " for quotes
"		{ for curly brackets, [ for square brackets, etfoldenablec...
" i is important because it selects based on current cursor position
" so diw would delete the current word, ci" would replace everything inside quotes, etc...
" ALSO --> <operator>a<operator> does the same thing as i except it includes the delimiters

" Move a line up and down
nnoremap <M-k> <cmd>m-2<CR>
nnoremap <M-j> <cmd>m+<CR>

" map redo to something easier to access
noremap ~ <C-R>

" start the visual block mode 
noremap + <C-v>

" Remap leader + bracket to go to next item within bracket
noremap <leader>0 ])
inoremap <leader>0 <Esc>])i
noremap <leader>9 [(
inoremap <leader>9 <Esc>[(a
noremap <leader>[ [{
inoremap <leader>[ <Esc>[{a
noremap <leader>] ]}
inoremap <leader>] <Esc>]}i

" ==================== Plugins ====================

" Install plugins via vim-plug --> just download vim plug that is all you need
" This code automatically installs the nececary plugins
call plug#begin('~/.config/nvim/plugged')

   "hold all deletes/yanks in memory, allowing you to choose
   Plug 'maxbrunsfeld/vim-yankstack'

   " better movement
   Plug 'easymotion/vim-easymotion'
   Plug 'tpope/vim-repeat'

   " Surround with quotes plugin
   Plug 'tpope/vim-surround'

   " Auto-comment plugin
   Plug 'numToStr/Comment.nvim'

   " TODO Highlight Plugin
   Plug 'folke/todo-comments.nvim'

   " Show marks on the side and add a bunch mark related operators
   Plug 'chentoast/marks.nvim'

   " Code completion (LSP's)
   Plug 'neoclide/coc.nvim', {'branch': 'release'}

call plug#end()


" EasyMotion Shortcut also add repeat support
" space = 2 char, f = jumpanywhere in line, z = jumpanywhere
" t = any word, F = next selection, Z = prev selection, T = end of any word
let g:EasyMotion_do_mapping = 0 " Disable default mappings
let g:EasyMotion_smartcase = 1 "case-insensitive
let g:EasyMotion_use_smartsign_us = 1 "similar looking character also works
let g:EasyMotion_startofline = 0 " keep cursor column when JK motion
hi EasyMotionTarget guibg=none guifg=#fc2d2d gui=bold
hi EasyMotionShade  guibg=none guifg=Gray gui=none
hi EasyMotionTarget2First guibg=none guifg=#f07d2b gui=bold,italic
hi EasyMotionTarget2Second guibg=none guifg=#bfb84e gui=italic
hi EasyMotionMoveHL guibg=none guifg=#4ce05e gui=bold
hi EasyMotionIncSearch guibg=none guifg=#4ce05e gui=bold
noremap <space> <Plug>(easymotion-s2)
noremap K <Plug>(easymotion-bd-jk)
noremap f <Plug>(easymotion-lineanywhere)
noremap t <Plug>(easymotion-bd-w)
noremap F <Plug>(easymotion-next)
noremap Z <Plug>(easymotion-prev)
noremap T <Plug>(easymotion-bd-e)
silent! call repeat#set("\<Plug>(easymotion-bd-w)", v:count)
silent! call repeat#set("\<Plug>(easymotion-jumptoanywhere)", v:count)
" EasyMotion Shortcut also add repeat support
" space = 2 char, f = jumpanywhere in line, z = jumpanywhere
" t = any word, F = next selection, Z = prev selection, T = end of any word
let g:EasyMotion_do_mapping = 0 " Disable default mappings
let g:EasyMotion_smartcase = 1 "case-insensitive
let g:EasyMotion_use_smartsign_us = 1 "similar looking character also works
let g:EasyMotion_startofline = 0 " keep cursor column when JK motion
hi EasyMotionTarget guibg=none guifg=#fc2d2d gui=bold
hi EasyMotionShade  guibg=none guifg=Gray gui=none
hi EasyMotionTarget2First guibg=none guifg=#f07d2b gui=bold,italic
hi EasyMotionTarget2Second guibg=none guifg=#bfb84e gui=italic
hi EasyMotionMoveHL guibg=none guifg=#4ce05e gui=bold
hi EasyMotionIncSearch guibg=none guifg=#4ce05e gui=bold
noremap <space> <Plug>(easymotion-s2)
noremap K <Plug>(easymotion-bd-jk)
noremap f <Plug>(easymotion-lineanywhere)
noremap t <Plug>(easymotion-bd-w)
noremap F <Plug>(easymotion-next)
noremap Z <Plug>(easymotion-prev)
noremap T <Plug>(easymotion-bd-e)
silent! call repeat#set("\<Plug>(easymotion-bd-w)", v:count)
silent! call repeat#set("\<Plug>(easymotion-jumptoanywhere)", v:count)
silent! call repeat#set("\<Plug>(easymotion-lineanywhere)", v:count)
silent! call repeat#set("\<Plug>(easymotion-s2)", v:count)
silent! call repeat#set("\<Plug>(easymotion-bd-jk)", v:count)
silent! call repeat#set("\<Plug>(easymotion-next)", v:count)
silent! call repeat#set("\<Plug>(easymotion-prev)", v:count)
silent! call repeat#set("\<Plug>(easymotion-bd-e)", v:count)

" comment out shortcut
nmap <leader>c gcc
vmap <leader>c gc
 
" Yankstack shortcuts 
" ```meta-p```  - cycle *backward* through your history of yanks
" ```meta-shift-p```  - cycle *forwards* through your history of yanks
silent! execute "set <M-p>=\<Esc>p"
silent! execute "set <M-p>=\<Esc>p"

" Surround Command  Description
"   y s <motion> <desired>      Add desired surround around text defined by <motion>
"   d s <existing>              Delete existing surround
"   c s <existing> <desired>    Change existing surround to desired
"   S <desired>                 Surround when in visual modes (surrounds full selection)

" Marks Command Description
"   mx              Set mark x
"   m,              Set the next available alphabetical (lowercase) mark
"   m;              Toggle the next available mark at the current line
"   dmx             Delete mark x
"   dm-             Delete all marks on the current line
"   dm<space>       Delete all marks in the current buffer
"   m]              Move to next mark
"   m[              Move to previous mark
"   m:              Preview mark. This will prompt you for a specific mark to
"                   preview; press <cr> to preview the next mark.
"   m[0-9]          Add a bookmark from bookmark group[0-9].

" CoC Plugin Settings ===============================

" Use tab for trigger completion with characters ahead and navigate
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" GoTo code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use z to show documentation in preview window
nnoremap <silent> z :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('z', 'in')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor
autocmd CursorHold * silent call CocActionAsync('highlight')

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Symbol renaming
nmap <leader>cn <Plug>(coc-rename)

" Formatting selected code
xmap <leader>cf  <Plug>(coc-format-selected)
nmap <leader>cf  <Plug>(coc-format-selected)

" Applying code actions to the selected code block
xmap <leader>cs  <Plug>(coc-codeaction-selected)
nmap <leader>cs  <Plug>(coc-codeaction-selected)

" Remap keys for applying code actions at the cursor position
nmap <leader>cc  <Plug>(coc-codeaction-cursor)
" Remap keys for apply code actions affect whole buffer
nmap <leader>ca  <Plug>(coc-codeaction-source)
" Apply the most preferred quickfix action to fix diagnostic on the current line
nmap <leader>cq  <Plug>(coc-fix-current)

" Remap keys for applying refactor code actions
nmap <silent> <leader>cr <Plug>(coc-codeaction-refactor)
xmap <silent> <leader>ct  <Plug>(coc-codeaction-refactor-selected)
nmap <silent> <leader>ct  <Plug>(coc-codeaction-refactor-selected)

" Run the Code Lens action on the current line
nmap <leader>cl  <Plug>(coc-codelens-action)

" Map function and class text objects --> operator mappings
" NOTE: Requires 'textDocument.documentSymbol' support from the language server
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

