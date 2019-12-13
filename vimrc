"enable plugins
call pathogen#infect()
call pathogen#helptags()

"colors
let g:molokai_original = 1
colorscheme molokai

"settings
set runtimepath^=~/.vim/bundle/ctrlp.vim
set nocompatible        "don't emulate vi
set noswapfile
set wildmenu            "command completion
set wildmode=full
set t_Co=256            "terminal colors
set laststatus=2        "always use status line
set nu                  "numbered lines
set rnu                 "relative numbered lines
set listchars=tab:>-,trail:-,extends:>,precedes:<,eol:$
set tw=80               "word wrap at 80cols
set colorcolumn=+0      "vertical bar at textwidth
"set cindent             "c-style autoindenting
set expandtab           "insert spaces when <tab> is hit
set ts=2                "spaces to display for ^I
set sts=2               "spaces to insert for expandtab
set sw=2                "spaces for indent, cindent
"set foldenable
"set foldcolumn=2
"set foldmethod=syntax
set showmatch           "show matching brackets
set matchtime=10        "for ten decisecs (1second)
set showcmd
set ignorecase

filetype plugin indent on
syntax on

" Hexmode map
command -bar Hexmode call hexmode#ToggleHex()
nnoremap <C-H> :Hexmode<CR>
inoremap <C-H> <Esc>:Hexmode<CR>
vnoremap <C-H> :<C-U>Hexmode<CR>

nnoremap <C-k> <PageUp>
nnoremap <C-j> <PageDown>

nnoremap \]] :YcmCompleter GoToImprecise<CR>
nnoremap \]c :YcmCompleter GoToDeclaration<CR>
nnoremap \]f :YcmCompleter GoToDefinition<CR>
nnoremap \]r :YcmCompleter GoToReferences<CR>
nnoremap \]t :YcmCompleter GetTypeImprecise<CR>
nnoremap \]d :YcmCompleter GetDocImprecise<CR>
nnoremap \]x :YcmCompleter FixIt<CR>
"command -nargs=0 YcmClearCompilationFlagCache YcmCompleter
"YcmClearCompilationFlagCache

"define a highlight and use it to highlight non-ASCII chars
highlight nonascii guibg=Red ctermbg=1 term=standout
au BufReadPost * syntax match nonascii "[^\u0000-\u007F]"

"au FileType mail s/\v +$//

" mail line wrapping
au BufRead /tmp/mutt-* set tw=72

if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
        \ | wincmd p | diffthis
endif

"highlight OverLength ctermbg=red ctermfg=white guibg=#592929
"au BufReadPost * syntax match OverLength /\%81v.*/

let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = 25

let g:airline_powerline_fonts = 1
"if !exists('g:airline_symbols')
"  let g:airline_symbols = {}
"endif
"let g:airline_symbols.space = "\ua0"
let g:airline_theme = 'molokai'
let g:airline#extensions#tabline#enabled = 0
let g:airline#extensions#tabline#show_buffers = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'


let g:go_fmt_command = "goimports"
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_operators = 1
let g:go_highlight_extra_types = 1
"let g:go_metalinter_autosave = 1
"let g:go_metalinter_autosave_enabled = ['vet', 'golint']
let g:go_list_type = "quickfix"
let g:go_info_mode = "guru"
let g:go_def_mode = "guru"
let g:go_auto_type_info = 0
let g:go_auto_sameids = 0
let g:go_debug = ["lsp"]

"let g:syntastic_go_checkers = ['golint', 'govet', 'gometalinter']
"let g:syntastic_go_gometalinter_args = ['--disable-all', '--enable=staticcheck']
"let g:syntastic_mode_map = { 'mode': 'active', 'passive_filetypes': ['go'] }
let g:syntastic_python_flake8_args = "--ignore E114,E111,E129"

" The private snippets dir.
let g:UltiSnipsSnippetsDir = '~/.vim/UltiSnips'
let g:UltiSnipsExpandTrigger="<F1>"
let g:UltiSnipsEditSplit="vertical"

let g:ctrlp_cmd = 'CtrlPBuffer'

let g:ycm_show_diagnostics_ui=1

hi Visual ctermfg=Yellow ctermbg=NONE cterm=bold,underline
