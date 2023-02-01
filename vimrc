set nocompatible " Throw away vi compatibility

"====== GENERAL CONFIG ======
set autoread                        " Set to auto read when a file is changed from the outside
set ttyfast                         " Optimize for fast terminal connection
set magic                           " For regular expressions turn magic on
set backspace=eol,start,indent      " Configure backspace so it acts as it should act
set whichwrap+=<,>,h,l              " Wrap arrow keys at the end of a line
set virtualedit=onemore             " Allow the cursor to go one character after the end of the line
set listchars=tab:>-,trail:·,nbsp:_ " Display trailing characters visually, eol:¬
set list
set mouse-=a                        " We don't need no mouse

"====== SEARCH ======
set ignorecase  " Ignore case when searching
set smartcase   " When searching try to be smart about cases
set hlsearch    " Highlight search results
set incsearch   " Makes search act like search in modern browsers

"====== LOOK & FEEL ======
set visualbell      " Flash screen instead of beep
set number          " Show line numbers
set ruler           " Always show current position
set cul             " Highlight current line
set colorcolumn=120 " Put a vertical line at 120 characters
"set title          " Show filename in window titlebar

"clear screen on exit
au VimLeave * :!clear

" Use a neat theme
colorscheme molokai
set background=dark
let g:molokai_original = 1

" Switch from block-cursor to vertical-line-cursor when going into/out of insert mode TODO
"let &t_SI = "\<Esc>]50;CursorShape=1\x7"
"let &t_EI = "\<Esc>]50;CursorShape=0\x7"

"====== INDENTATION ======
set ai          " Auto indent
set si          " Smart indent
set expandtab   " Use spaces instead of tabs
set smarttab    " At start of line, <Tab> inserts shiftwidth spaces, <Bs> deletes shiftwidth spaces.
" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4

"====== WRAP ======
set wrap        " Wrap lines
set linebreak   " Wrap lines at convenient points

"====== SYNTAX HL ======
syntax on       " Turn syntax highlighting on
filetype on     " Let Vim detect the filetype
set showmatch   " Show matching brackets
set matchtime=5 " Duration to show matching brace

"====== COMPLETION ======
set completeopt=longest,menu
set wildmode=longest:full
set wildmenu
set wildignorecase

"====== REMAPS ======
" toggle auto-indent for code paste mode w/ F2 key		
set pastetoggle=<F2>

" toggle line numbers w/ F3 key
noremap <F3> :set nu!<CR>
inoremap <F3> <C-O>:set nu!<CR>

"Bubble single lines-TODO
nnoremap <C-Down> ddp
nnoremap <C-Up> ddkP

" move to beginning/end of line
nnoremap B ^
nnoremap E $

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
