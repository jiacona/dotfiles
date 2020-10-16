call plug#begin('~/.vim/plugged')

Plug 'altercation/vim-colors-solarized'
Plug 'amadeus/vim-mjml'
Plug 'dense-analysis/ale'
Plug 'itchyny/lightline.vim'
Plug 'janko/vim-test'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/seoul256.vim'
Plug 'jxnblk/vim-mdx-js'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'mileszs/ack.vim'
Plug 'mtth/scratch.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-haml'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-surround'
Plug 'vim-syntastic/syntastic'

call plug#end()

syntax on
filetype plugin indent on

" Colorscheme
let g:seoul256_background = 235
set background=dark
colorscheme seoul256

" Ensure that the line-number background is transparent
hi clear LineNr

" Ensure that the sign-column background is transparent
hi clear SignColumn
"
" Highlighting rule to catch leading/trainling whitespace
au BufRead,BufNew,BufNewFile * syn match ExtraSpace /^\s\+\|\s\+$/

" Right rule
set colorcolumn=88

" General
set backspace=eol,indent,start
set cursorline
set encoding=utf-8
set incsearch
set laststatus=2
set nobackup
set nocompatible
set nohls
set notitle
set number
set scrolloff=3
set showmatch
set showtabline=2
set ignorecase smartcase
set ttyfast
set lazyredraw
set visualbell
set wildmode=list:longest
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set shiftwidth=2
set tabstop=2
set expandtab

let loaded_matchparen = 1
let mapleader = ','
set timeoutlen=200

map <Leader>b :Buf<CR>

" Language server
let g:LanguageClient_serverCommands = { 'ruby': ['solargraph', 'stdio'] }

" testing mappings
let test#strategy = "basic"
let test#javascript#jest#options = "--silent"
let test#ruby#rspec#options = {'file': '--format documentation'}

map <Leader>t :TestFile<CR>
map <Leader>f :TestNearest<CR>
map <Leader>tt :TestLast<CR>
map <Leader>a :TestSuite<CR>
map <Leader>v :TestVisit<CR>

" Terminal normal mode
tmap <C-o> <C-\><C-n>

" Toggle Highlight-Whitespace Helper
function! ToggleHighlightWhitespace()
  if !exists('g:highlight_whitespace')
    let g:highlight_whitespace=0
  end
  if g:highlight_whitespace
    hi clear ExtraSpace
    let g:highlight_whitespace=0
  else
    hi ExtraSpace ctermbg=1 guibg=red
    let g:highlight_whitespace=1
  endif
  redraw!
endfunction
noremap <F4> :call ToggleHighlightWhitespace()<CR>

" Toggle Paste-Mode Helper
function! TogglePasteMode()
  set paste!
  redraw!
endfunction
noremap <F2> :call TogglePasteMode()<CR>

" Lightline
function! CurrentFilename()
  return ('' != expand('%:p') ? substitute(expand('%:p'), expand('$HOME'), '~', 'g') : '[No Name]')
endfunction

let g:lightline = {
      \ 'colorscheme': 'solarized',
      \ 'active': {
      \   'left': [
      \      ['mode', 'paste'],
      \      ['fugitive', 'readonly', 'filename', 'modified']
      \   ]
      \ },
      \ 'component': {
      \   'modified': '%{&filetype=="help"?"":&modified?"+":&modifiable?"":"-"}',
      \   'fugitive': '%{exists("*fugitive#head")?fugitive#head():""}'
      \ },
      \ 'component_function': {
      \   'filename': 'CurrentFilename'
      \ },
      \ 'component_visible_condition': {
      \   'modified': '(&filetype!="help"&&(&modified||!&modifiable))',
      \   'fugitive': '(exists("*fugitive#head") && ""!=fugitive#head())'
      \ },
      \ 'separator': { 'left': '', 'right': '' },
      \ 'subseparator': { 'left': '', 'right': '' }
      \ }

" "improve autocomplete menu color
" highlight Pmenu ctermbg=238 gui=bold

noremap H ^
noremap L $


" Toggle word wrap
function! ToggleWordWrap()
  if &tw
    echo "Turning off text wrapping"
    setlocal tw=0
  else
    echo "Turning on text wrapping at col 88"
    setlocal tw=88
  endif
endfunction
noremap <leader>ww :call ToggleWordWrap()<CR>

" fzf integration
noremap <c-p> :GFiles --cached --others --exclude-standard<CR>
noremap <leader>s :Ag!<CR>
noremap <leader>sw :exe 'Ag!' expand('<cword>')<CR>
noremap <leader>l :Lines<CR>
noremap <leader>g :Commits<CR>
noremap <leader>gb :BCommits<CR>

" Linting with ale
nmap <silent> <leader>f :ALEFix<CR>
let g:ale_sign_error = '>>'
let g:ale_sign_warning = '>>'
let g:ale_fix_on_save = 1
let g:ale_fixers = {
      \ 'javascript': ['prettier'],
      \ 'jsx': ['prettier'],
      \ 'ruby': ['rubocop']
      \ }
let g:ale_history_enabled = 0
let g:ale_lint_on_enter = 0
let g:ale_lint_on_text_changed = 'never'
let g:ale_open_list = 0

" Set up paths and support for jumping to js includes that don't have the
" .js prefix
set path=.,app/javascript,spec/javascript,,
set includeexpr=substitute(v:fname,'$','.js','g')

"============================================"
" COC (https://github.com/neoclide/coc.nvim) "
"============================================"

" if hidden is not set, TextEdit might fail.
set hidden

" Some servers have issues with backup files, see #649
set nowritebackup

" Better display for messages
set cmdheight=2

" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" Or use `complete_info` if your vim support it, like:
" inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)
