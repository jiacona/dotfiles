call plug#begin()

Plug 'amadeus/vim-mjml'
Plug 'bkad/CamelCaseMotion'
Plug 'dense-analysis/ale'
Plug 'itchyny/lightline.vim'
Plug 'janko/vim-test'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/seoul256.vim'
Plug 'mileszs/ack.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'pedrohdz/vim-yaml-folds'
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-projectionist'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-rails', { 'for': 'ruby' }

call plug#end()

set termguicolors

syntax on
filetype plugin indent on

map <silent> w <Plug>CamelCaseMotion_w
map <silent> b <Plug>CamelCaseMotion_b
map <silent> e <Plug>CamelCaseMotion_e

sunmap w
sunmap b
sunmap e

" Yank to system clipboard
noremap Y "+y

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

" E605: Exception not caught: Third party code is using fugitive#head() which has been removed. Change it to FugitiveHead()
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

:imap jj <Esc>

let loaded_matchparen = 1
let mapleader = ','
set timeoutlen=200

map <Leader>b :Buf<CR>

" Language server
let g:LanguageClient_serverCommands = { 'ruby': ['solargraph', 'stdio'] }

" testing mappings
let test#strategy = "neovim"
let test#javascript#jest#options = "--silent"
let test#ruby#rspec#options = {'file': '--format documentation'}

map <Leader>t :TestFile<CR>
map <Leader>T :TestNearest<CR>
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
      \ 'colorscheme': 'seoul256',
      \ 'active': {
      \   'left': [
      \      ['mode', 'paste'],
      \      ['fugitive', 'readonly', 'filename', 'modified']
      \   ]
      \ },
      \ 'component': {
      \   'modified': '%{&filetype=="help"?"":&modified?"+":&modifiable?"":"-"}',
      \   'fugitive': '%{exists("*fugitive#head")?FugitiveHead():""}'
      \ },
      \ 'component_function': {
      \   'filename': 'CurrentFilename'
      \ },
      \ 'component_visible_condition': {
      \   'modified': '(&filetype!="help"&&(&modified||!&modifiable))',
      \   'fugitive': '(exists("*FugitiveHead") && ""!=FugitiveHead())'
      \ }
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
noremap <leader>s :Rg!<CR>
noremap <leader>sw :exe 'Rg!' expand('<cword>')<CR>
noremap <leader>l :Lines<CR>
noremap <leader>g :Commits<CR>
noremap <leader>gb :BCommits<CR>

" Linting with ale
nmap <silent> <leader>f :ALEFix<CR>
let g:ale_sign_error = '>>'
let g:ale_sign_warning = '>>'
let g:ale_fix_on_save = 0
let g:ale_fixers = {
      \ 'javascript': ['prettier'],
      \ 'typescriptreact': ['prettier'],
      \ 'typescript': ['prettier'],
      \ 'jsx': ['prettier'],
      \ 'ruby': ['rubocop']
      \ }
let g:ale_history_enabled = 0
let g:ale_lint_on_enter = 1
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
set cmdheight=3

" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=yes

" Use <Tab> and <S-Tab> to navigate the completion list:
function! CheckBackSpace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
inoremap <expr> <Tab> 
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" : 
      \ CheckBackSpace() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr> <S-Tab> coc#pum#visible() ? coc#pum#prev(1) : "\<S-Tab>"
let g:coc_snippet_next = '<tab>'

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> gp <Plug>(coc-diagnostic-prev)
nmap <silent> gn <Plug>(coc-diagnostic-next)

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

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

" Spellcheck git commits
autocmd FileType gitcommit setlocal spell
