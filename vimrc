" detect OS {{{
let s:is_windows = has('win32') || has('win64')
let s:is_cygwin = has('win32unix')
let s:is_macvim = has('gui_macvim')
let s:is_linux = has('gui_gnome') || has('gui_gtak2')
"}}}

" base configuration {{{
set nocompatible
let mapleader=","
set number
set relativenumber
set backspace=indent,eol,start
set autoread
set textwidth=80
set colorcolumn=+1
set iskeyword+=-
set linebreak
set formatoptions+=mB
set wrap
set whichwrap+=<,>,h,l
set scrolloff=3
set cursorline
set laststatus=2
set cmdheight=2
set autochdir

set noerrorbells
set novisualbell
set t_vb=

set hlsearch
set incsearch
set ignorecase
set smartcase

set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set smarttab

set autoindent
set smartindent
set cindent

set foldenable
set foldcolumn=2
set foldmethod=marker
set foldnestmax=99
set foldopen=block,hor,insert,jump,mark,percent,quickfix,search,tag,undo

set helplang=zh
set encoding=utf-8
set langmenu=zh_CN.utf-8
language messages zh_CN.utf-8
set fileencoding=utf-8
set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1
let &termencoding=&encoding
set fileformats=unix,dos,mac
if has('multi_byte')
  scriptencoding utf-8
  set listchars=tab:→\ ,trail:█,eol:¬,precedes:«,extends:»
endif

if has('persistent_undo')
  set undofile
  set undolevels=1000
  set history=1000

  if s:is_windows
    set undodir=$VIM\_undodir
  else
    set undodir=~/.vim/.undodir
  endif
endif
set viminfo='1000,f1,:1000,/1000

set noswapfile
set nobackup
set nowritebackup

set wildmode=list:longest
set wildmenu

set tags=tags;/
set showfulltag

command W w !sudo tee % > /dev/null
" }}}

" functions {{{
function! CompileRun()
  execute "w"
  if &filetype == 'c'
    execute "!gcc % -g -o %<"
    execute "!%<"
  endif
  if &filetype == 'cpp'
    execute "!g++ % -g -o %<"
    execute "!%<"
  endif
endfunction

function! DebugRun()
  execute "w"
  execute "!gdb ./%<"
endfunction

function!  InsertHeader()
  if &filetype == 'c'
    call append(0,"/**")
    call append(1," * Author        : Cai Junqi")
    call append(2," * Email         : caijq4ever@gmail.com")
    call append(3," * Last modified :")
    call append(4," * Description   :")
    call append(5," */")
  endif
  if &filetype == 'php'
    call append(0,"<?php")
    call append(1,"/**")
    call append(2," * Author        : Cai Junqi")
    call append(3," * Email         : caijq4ever@gmail.com")
    call append(4," * Last modified :")
    call append(5," * Description   :")
    call append(6," */")
  endif
  if &filetype == 'javascript'
    call append(0,"/**")
    call append(1," * Author        : Cai Junqi")
    call append(2," * Email         : caijq4ever@gmail.com")
    call append(3," * Last modified :")
    call append(4," * Description   :")
    call append(5," */")
  endif
  autocmd BufNewFile * normal G
endfunction

function! LastModified()
  if line("$") > 20
    let l = 20
  else
    let l = line("$")
  endif
  execute "1," . l . "g#Last modified : #s#Last modified : .*#Last modified : " .
        \ strftime("%Y-%m-%d %H:%M:%S")
endfunction

function! CodeSniffer()
  if g:code_sniffer_open
    call add(g:syntastic_php_checkers, 'phpcs')
    let g:syntastic_php_phpcs_args = '--standard=PSR2 -n'
    execute 'SyntasticCheck phpcs'
    let g:code_sniffer_open = 0
  else
    execute 'SyntasticReset'
    let g:code_sniffer_open = 1
  endif
endfunction
" }}}

" maps {{{
nnoremap <silent> <F1> :Startify<CR>
nnoremap <silent> <F2> :NERDTreeToggle<CR>
nnoremap <silent> <F3> :TagbarToggle<CR>
nnoremap <silent> <F4> :!ctags -R --fields=+iaS --extra=+q *<CR>
" <F5> is occupied
nnoremap <silent> <F6> :call CompileRun()<CR>
nnoremap <silent> <F7> :call DebugRun()<CR>
nnoremap <silent> <F8> :!php %:t<CR>
nnoremap <silent> <F9> :!php -S localhost:80<CR>
" <F10> is occupied
nnoremap <silent> <F11> :call CodeSniffer()<CR>
nnoremap <silent> <F12> :!phpcbf --standard=psr2 %<CR>
nnoremap <C-Tab> <C-w><C-w>
inoremap <C-b> <Left>
inoremap <C-n> <Down>
inoremap <C-p> <Up>
inoremap <C-f> <Right>
inoremap <C-d> <Delete>
nnoremap <silent> <Leader>T :%s/\s\+$//g<CR>
nnoremap <silent> <leader>M :%s/\r//g<CR>
nnoremap <silent> <Leader>l :set list!<CR>
nnoremap <leader>sw :execute "vimgrep ".expand("<cword>")." %"<cr>:copen<cr>
nnoremap <leader>sf :execute 'vimgrep /'.@/.'/g %'<cr>:copen<cr>
nmap <Leader>a& :Tabularize /&<CR>
vmap <Leader>a& :Tabularize /&<CR>
nmap <Leader>a= :Tabularize /=<CR>
vmap <Leader>a= :Tabularize /=<CR>
nmap <Leader>a: :Tabularize /:<CR>
vmap <Leader>a: :Tabularize /:<CR>
nnoremap <silent> <Space> :noh <CR>
map <Leader> <Plug>(easymotion-prefix)
map <silent> <A-n> :enew<CR>
nnoremap <silent> <A-q> :bd<CR>
nmap <leader>1 <Plug>AirlineSelectTab1
nmap <leader>2 <Plug>AirlineSelectTab2
nmap <leader>3 <Plug>AirlineSelectTab3
nmap <leader>4 <Plug>AirlineSelectTab4
nmap <leader>5 <Plug>AirlineSelectTab5
nmap <leader>6 <Plug>AirlineSelectTab6
nmap <leader>7 <Plug>AirlineSelectTab7
nmap <leader>8 <Plug>AirlineSelectTab8
nmap <leader>9 <Plug>AirlineSelectTab9
nnoremap [b :bp<CR>
nnoremap ]b :bn<CR>
nmap <Leader>tn :tnext<CR>
nmap <Leader>tp :tprevious<CR>
" }}}

" {{{ vundle
filetype off
if s:is_windows
  set rtp+=$VIM/bundle/Vundle.vim
  call vundle#begin("$VIM/bundle")
else
  set rtp+=~/.vim/bundle/Vundle.vim
  call vundle#begin()
endif
" {{{ plugins
Plugin 'gmarik/Vundle.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'mhinz/vim-startify' " {{{
let g:startify_files_number = 20
let g:startify_list_order = [
      \ ['   LRU:'],
      \ 'files',
      \ ['   LRU within this dir:'],
      \ 'dir',
      \ ['   Sessions:'],
      \ 'sessions',
      \ ['   Bookmarks:'],
      \ 'bookmarks',
      \ ]
let g:startify_bookmarks     = ['']
let g:startify_custom_header = [
      \ '____/\\\________/\\\___/\\\\\\\\\\\___/\\\\____________/\\\\__________',
      \ '____\/\\\_______\/\\\__\/////\\\///___\/\\\\\\________/\\\\\\__________',
      \ '_____\//\\\______/\\\_______\/\\\______\/\\\//\\\____/\\\//\\\__________',
      \ '_______\//\\\____/\\\________\/\\\______\/\\\\///\\\/\\\/_\/\\\__________',
      \ '_________\//\\\__/\\\_________\/\\\______\/\\\__\///\\\/___\/\\\__________',
      \ '___________\//\\\/\\\__________\/\\\______\/\\\____\///_____\/\\\__________',
      \ '_____________\//\\\\\___________\/\\\______\/\\\_____________\/\\\__________',
      \ '_______________\//\\\_________/\\\\\\\\\\\__\/\\\_____________\/\\\__________',
      \ '_________________\///_________\///////////___\///______________\///___________',
      \ '',
      \ '                  Get busy coding, or get busy dying.',
      \ ]
let g:startify_custom_footer =
      \ ['', "   Vim is charityware. Please read ':help uganda'.", '']
"}}}
Plugin 'scrooloose/nerdtree' "{{{
let NERDTreeMinimalUI = 1
let NERDTreeQuitOnOpen = 1
let NERDTreeShowBookmarks = 1
let NERDTreeDirArrows = 1
let NERDTreeWinSize = 30
let NERDTreeIgnore = ['\~$', '\.exe$', '\.dll$', '\.zip$', '\.rar$', '\.swp$']
"}}}
Plugin 'scrooloose/nerdcommenter'
Plugin 'majutsushi/tagbar' "{{{
let g:tagbar_iconchars = ['▸', '▾']
"}}}
Plugin 'a.vim'
Plugin 'tomasr/molokai'
Plugin 'scrooloose/syntastic' " {{{
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_php_checkers = ['php']
let g:code_sniffer_open = 1
"}}}
Plugin 'terryma/vim-multiple-cursors' " multiple cursors(press ctrl-n)
Plugin 'AutoComplPop'
Plugin 'Raimondi/delimitMate'
Plugin 'MarcWeber/vim-addon-mw-utils'
Plugin 'tomtom/tlib_vim'
Plugin 'garbas/vim-snipmate' " snipmate depends on vim-addon-mw-utils and tlib
Plugin 'honza/vim-snippets' " {{{
let g:snipMate = {}
let g:snipMate.scope_aliases = {}
let g:snipMate.scope_aliases['php'] = 'php,html,js,css,yii,yii-chtml'
let g:snips_author = "Junqi Cai"
"}}}
Plugin 'mattn/emmet-vim' " {{{
let g:user_emmet_expandabbr_key = '<C-e>'
let g:use_emmet_complete_tag = 1
"}}}
Plugin 'mattn/calendar-vim'
Plugin 'pangloss/vim-javascript'
Plugin 'othree/javascript-libraries-syntax.vim'
Plugin 'othree/html5.vim'
Plugin 'othree/html5-syntax.vim'
Plugin 'skammer/vim-css-color'
Plugin 'hail2u/vim-css3-syntax'
Plugin 'elzr/vim-json'
Plugin 'godlygeek/tabular'
Plugin 'kien/ctrlp.vim'
Plugin 'tpope/vim-markdown' "{{{
let g:markdown_fenced_languages = ['php', 'html', 'javascript']
"}}}
Plugin 'Lokaltog/vim-easymotion'
Plugin 'mileszs/ack.vim'
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif
Plugin 'bling/vim-airline' " {{{
let g:airline_theme ='molokai'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_format ='%s: '
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline#extensions#tabline#buffer_idx_mode = 1
"}}}
Plugin 'joonty/vdebug'
let g:vdebug_options = {'break_on_open': 0}
let g:vdebug_options = {'server': 'www.example.com'}
let g:vdebug_options = {'port': '9000'}
call vundle#end()
"}}}
syntax on
syntax enable

filetype on
filetype plugin on
filetype plugin indent on
"}}}

" {{{ theme & font
set background=dark
colorscheme molokai

if has("gui_running")
  set guioptions=egmtr
  set lines=999 columns=999

  if s:is_macvim
    set transparency=10
    set macmeta
    if g:airline_powerline_fonts
        set guifont=DejaVu\ Sans\ Mono\ for\ Powerline\ 12
    else
        set guifont=DejaVu\ Sans\ Mono\ 12
    endif
    let g:tagbar_ctags_bin='/usr/local/bin/ctags'
  elseif s:is_windows
    if g:airline_powerline_fonts
        set guifont=DejaVu_Sans_Mono_for_Powerline:h12:cANSI
    else
        set guifont=DejaVu_Sans_Mono:h12:cANSI
    endif
    let g:tagbar_ctags_bin=$VIMRUNTIME.'/ctags.exe'
  elseif s:is_linux
    if g:airline_powerline_fonts
        set guifont=DejaVu\ Sans\ Mono\ for\ Powerline\ 12
    else
        set guifont=DejaVu\ Sans\ Mono\ 12
    endif
    let g:tagbar_ctags_bin='/usr/local/bin/ctags'
  endif
else
  set t_Co=256
  set mouse=a
endif
"}}}

" {{{ wildignore
set wildignore+=*/tmp/*,*.so,*.swp,*.zip " Linux/MacOSX
set wildignore+=*\\tmp\\*,*.swp,*.zip,*.exe,*.chm,*.chw,*.pdf,*.doc " Windows
set wildignore+=*.aux,*.out,*.toc " LaTeX intermediate files
set wildignore+=*.jpg,*.bmp,*.gif " binary images
set wildignore+=*.luac " Lua byte code
set wildignore+=*.o,*.obj,*.exe,*.dll,*.manifest " compiled object files
set wildignore+=*.pyc " Python byte code
set wildignore+=*.spl " compiled spelling word lists
set wildignore+=*.sw? " Vim swap files
"}}}

" {{{ popup
" Popup menu: normal item
hi pmenu guibg=#3C3F41 guifg=#88898A
" Popup menu: seleted item
hi PmenuSel ctermfg=7 ctermbg=4 guibg=#4B4E50 guifg=#9B68A0
" Highlighting matching parens
hi MatchParen ctermfg=7 ctermbg=4
"}}}

" {{{ autocmd
if has("autocmd")
  autocmd BufNewFile *.c,*.php,*.js exec ":call InsertHeader()"
  "autocmd BufNewFile *.php r filename

  autocmd BufWritePre,FileWritePre *.c,*.php,*.js ks|call LastModified()|'s

  autocmd BufReadPost *
        \ if line("'\"") > 1 && line("'\"") <= line("$") |
        \ exe "normal! g'\"" |
        \ endif

  autocmd WinLeave * set nocursorline
  autocmd WinEnter * set cursorline

  autocmd FileType php setlocal omnifunc=phpcomplete#CompletePHP

  autocmd BufReadPost $MYVIMRC setlocal tabstop=2 softtabstop=2 shiftwidth=2

  autocmd BufNewFile,BufReadPost *.{md,markdown} set filetype=markdown
  autocmd FileType md,markdown setlocal tabstop=2 softtabstop=2 shiftwidth=2
endif
"}}}
