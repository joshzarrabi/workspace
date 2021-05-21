" Plug for plugins
call plug#begin('~/.vim/plugged')

Plug 'flazz/vim-colorschemes'  " All the colorschemes
Plug 'tpope/vim-fugitive'      " Git Commands
Plug 'fatih/vim-go'            " Lets do go development
Plug 'pangloss/vim-javascript' " Lets do javascript development
Plug 'tpope/vim-unimpaired'    " Pairs of handy bracket mappings
Plug 'tpope/vim-commentary'    " Make commenting easier
Plug 'tpope/vim-vinegar'       " Make netrw way better
Plug 'mileszs/ack.vim'         " search
Plug 'dense-analysis/ale'      " Linting
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' } " Autocomplete
Plug 'cespare/vim-toml'
Plug 'airblade/vim-gitgutter'
Plug 'leafgarland/typescript-vim'
Plug 'davidhalter/jedi-vim'
Plug 'ctrlpvim/ctrlp.vim'


call plug#end()

syntax on " Syntax highlighting FTW
set background=dark " Set background to dark for base16
colorscheme tomorrow-night " Set colorscheme to hybrid
set directory=/tmp " Move swp to a standard location
:let mapleader = ',' " Remap the leader key

" Yank to system clipboard
vnoremap <leader>y "*y
nnoremap <leader>y "*y

" Search mappings: These will make it so that going to the next one in a
" search will center on the line it's found in.
nnoremap n nzzzv
nnoremap N Nzzzv

" Maintain undo history between sessions
set undofile
set undodir=~/.config/nvim/undodir

" Setting Spacing and Indent (plus line no)
set nu
set tabstop=2 shiftwidth=2 expandtab
set ts=2
set nowrap

" Set 256 colors
set t_Co=256
set guifont=Inconsolata:h16

" Hidden characters
set listchars=tab:\ \ ,trail:█
set list

" Auto update commands run not too fast and not too slow
set updatetime=500

" Go Declaration
let g:go_fmt_command = "goimports"
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_interfaces = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
let g:go_highlight_function_parameters = 1
let g:go_highlight_function_calls = 1
let g:go_auto_type_info = 0

" Turn on go-implements
au FileType go nmap <Leader>i <Plug>(go-implements)

" Open test file in new window
au FileType go nmap <Leader>a <Plug>(go-alternate-vertical)

" Open godoc in a vertical split
au FileType go nmap <Leader>d <Plug>(go-doc-vertical)

" Linting
let g:ale_linters = {
\   'go': ['go build', 'golangci-lint'],
\   'javascript': ['eslint', 'flow-language-server'],
\}
let g:ale_go_golangci_lint_package = 1
let g:ale_go_golangci_lint_options = '--enable bodyclose --enable golint --enable gosec --enable unparam --enable scopelint --enable godox --enable testpackage --disable unused --disable deadcode'

" Fixing
let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\}

" Unbreak YAML indents
autocmd FileType yaml setlocal indentexpr=

" Enable autocompletion
let g:deoplete#enable_at_startup = 1
call deoplete#custom#option('auto_complete', v:false)
call deoplete#custom#option('sources', {
\ '_': ['ale'],
\})
inoremap <silent><expr> <TAB>
		\ pumvisible() ? "\<C-n>" :
		\ <SID>check_back_space() ? "\<TAB>" :
		\ deoplete#manual_complete()
function! s:check_back_space() abort "{{{
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction"}}}

let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1

" The Silver Searcher
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0

  " bind Ag command
  command -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!
endif

" hit the space bar to remove search highlights
nnoremap <space> :noh<cr>
