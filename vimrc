

" Enable filetype plugins
"filetype plugin on
"filetype indent on

set nocompatible " Throw away vi compatibility
set autoread     " Set to auto read when a file is changed from the outside
set ruler        " Always show current position
set number       " Show line numbers

set ignorecase   " Ignore case when searching
set smartcase    " When searching try to be smart about cases 
set hlsearch     " Highlight search results
set incsearch    " Makes search act like search in modern browsers
set magic        " For regular expressions turn magic on
"set title        " Show filename in window titlebar

set ai           " Auto indent
set si           " Smart indent
set wrap         " Wrap lines
set cul          " Highlight current line

set ttyfast      " Optimize for fast terminal connection
set visualbell   " Flash screen instead of beep

set colorcolumn=120
set whichwrap+=<,>,h,l "Wrap arrow keys at the end of a line
set backspace=eol,start,indent " Configure backspace so it acts as it should act
set mouse-=a

"Change the colors
colorscheme molokai
"set background=dark

let g:molokai_original = 1

"======TABS======
" Use spaces instead of tabs
set expandtab

" Be smart when using tabs ;)
"set smarttab

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4

syntax on
filetype on

"====Key remaps====
"Bubble single lines-TODO
nnoremap <C-Down> ddp
nnoremap <C-Up> ddkP

" toggle auto-indent for code paste mode w/ F2 key
set pastetoggle=<F2>

" move to beginning/end of line
nnoremap B ^
nnoremap E $

set listchars=tab:>-,trail:-
set list

function ShowSpaces(...)
  let @/='\v(\s+$)|( +\ze\t)'
  let oldhlsearch=&hlsearch
  if !a:0
    let &hlsearch=!&hlsearch
  else
    let &hlsearch=a:1
  end
  return oldhlsearch
endfunction

function TrimSpaces() range
  let oldhlsearch=ShowSpaces(1)
  execute a:firstline.",".a:lastline."substitute ///gec"
  let &hlsearch=oldhlsearch
endfunction

command -bar -nargs=? ShowSpaces call ShowSpaces(<args>)
command -bar -nargs=0 -range=% TrimSpaces <line1>,<line2>call TrimSpaces()
nnoremap <F12>     :ShowSpaces 1<CR>
nnoremap <S-F12>   m`:TrimSpaces<CR>``
vnoremap <S-F12>   :TrimSpaces<CR>


"in order to be able to use molokai theme
if &term =~ "xterm"
 " 256 colors
  let &t_Co = 256
  " restore screen after quitting
  let &t_ti = "\<Esc>7\<Esc>[r\<Esc>[?47h"
  let &t_te = "\<Esc>[?47l\<Esc>8"
  if has("terminfo")
    let &t_Sf = "\<Esc>[3%p1%dm"
    let &t_Sb = "\<Esc>[4%p1%dm"
  else
    let &t_Sf = "\<Esc>[3%dm"
    let &t_Sb = "\<Esc>[4%dm"
 endif
endif
