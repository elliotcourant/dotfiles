set nocompatible
filetype off

" Fuzzy file finder
set rtp+=/usr/local/opt/fzf

" Vim-Plug
filetype plugin indent on

call plug#begin('~/.local/share/nvim/plugged')

" LANGUAGES
" -Golang
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

" - Dockerfile "
Plug 'ekalinin/Dockerfile.vim'

" AUTOCOMPLETE
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Javascript/Typescript
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'
Plug 'pangloss/vim-javascript'
Plug 'mattn/emmet-vim'

" THEMES
" -Editor Theme
Plug 'elliotcourant/material.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'jaxbot/semantic-highlight.vim'

" EDITOR
Plug 'tpope/vim-fugitive'

" MISC
Plug '/usr/local/opt/fzf'
Plug 'easymotion/vim-easymotion'
Plug 'jiangmiao/auto-pairs'
Plug 'junegunn/fzf.vim'
Plug 'junegunn/vim-easy-align'
Plug 'mileszs/ack.vim'
Plug 'qpkorr/vim-bufkill'
Plug 'terryma/vim-multiple-cursors'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-surround'
Plug 'voldikss/vim-floaterm'

call plug#end()

" All Key Bindings "
let mapleader = "'"
nnoremap <Leader><Up>    :resize +10<CR>
nnoremap <Leader><Down>  :resize -10<CR>
nnoremap <Leader><Left>  :vertical resize +10<CR>
nnoremap <Leader><Right> :vertical resize -10<CR>
nmap     <Leader>d  :bd<CR>     " Close buffer without closing split
nmap     <Tab>      <C-w>
nmap     <Tab><Tab> <C-w><C-w> " Cycle focus of splits on double-tab

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)
nmap <Leader>z :echo cfi#format("%s", "")<CR>

if &diff
    au BufLeave <buffer> :qa
endif

function! SetGoOptions()
    set completeopt-=preview

    " Golang specific mappings
    nmap <Leader>b  :GoDebugBreakpoint<CR>
    map <F6>        :GoDebugStart<CR>
    map <F4>        :GoDebugStop<CR>
    map <F7>        :GoDebugContinue<CR>
    map <F9>        :GoDebugNext<CR>
    map <F10>       :GoDebugStep<CR>
    map <F11>       :GoDebugStepOut<CR>
    nmap <Leader>gt :GoTestFunc!<CR>
endfunction

function! SetJsonOptions()
    set completeopt-=preview
endfunction

function! SetVimOptions()
    set completeopt-=preview
endfunction

" Easy Align Keybindings "
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" Easy Motion Keybindings "
map  <Leader>w <Plug>(easymotion-bd-w)
nmap <Leader>W <Plug>(easymotion-overwin-w)
map  <Leader>q <Plug>(easymotion-bd-jk)
nmap <Leader>Q <Plug>(easymotion-overwin-line)
map  <Leader>l <Plug>(easymotion-bd-jk)
nmap <Leader>L <Plug>(easymotion-overwin-line)

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

"" Nerd Tree Keybindings "
nmap <Leader>n :NERDTreeToggle<CR>

" FZF Keybindings "
" nmap <Leader>t :Tags<CR>
nmap <Leader>f :Files<CR>
noremap <c-\> :call fzf#vim#tags(expand('<cword>'), {'options': '--exact --select-1 --exit-0'})<CR>

nmap <Leader>T :GoDecls<CR>

nnoremap <Leader>h :SemanticHighlightToggle<cr>

let g:user_emmet_leader_key='<Leader>'

" Ag Keybindings "
nmap <silent> <leader>ev :e $MYVIMRC<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>
nmap ; :Buffers<CR>

cnoreabbrev Ack Ack!
nnoremap <Leader>a :Ack!<Space>
if executable('ag')
    let g:ackprg = 'ag --vimgrep'
endif

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-y>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" Command Aliases "
command! Split split
command! WQ    wq
command! Wq    wq
command! Qa    qa
command! QA    qa
command! W     w
command! Q     q
command! D     call deoplete#toggle()
command! VS    vs
command! Vs    vs

command! Commit FloatermNew --autoclose=2 git add -A && git commit -a
command! Push FloatermNew --name=push --autoclose=1 git push
command! Status FloatermNew --name=status --autoclose=0 git status
command! Term FloatermNew --name=terminal --autoclose=2

" SETTINGS
set number
set expandtab ts=2 sw=2 ai si
set bs=2
set laststatus=2
set clipboard+=unnamedplus
set autoread    " Update buffer when file is modified externally.
set showcmd     " I want to see the command keys
set ignorecase  " searches are case insensitive...
set smartcase   " ... unless they contain at least one capital letter
set hidden
set ttyfast
set noshowmode
set nowrap
set go+=b.
set mouse=a
set rtp+=/.fzf
set completeopt=preview,menu,noinsert,menuone
set colorcolumn=120

" Stray javascript setting? "
let g:used_javascript_libs = 'underscore,backbone,mustache,jquery'

" GoLang Stuff
let g:go_term_mode                   = "split"
let g:go_term_enabled                = 1
let g:go_fold_enable                 = ['block', 'import', 'varconst', 'package_comment']
let g:go_highlight_generate_tags     = 1
let g:go_highlight_build_constraints = 1
let g:go_highlight_fields            = 0
let g:go_highlight_function_calls    = 1
let g:go_highlight_functions         = 1
let g:go_highlight_interfaces        = 1
let g:go_highlight_methods           = 1
let g:go_highlight_operators         = 1
let g:go_highlight_structs           = 1
let g:go_highlight_types             = 1
let g:go_highlight_format_strings    = 1

let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 0
let g:airline#extensions#tagbar#enabled = 0

" " set completeopt-=preview
" set completeopt=menu,noinsert
" autocmd CompleteDone * silent! pclose!

" Vim theme settings. "
let g:airline_theme = 'material'
let g:material_theme_style = 'dark'
set background=dark
colorscheme material

if (has("nvim"))
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif

if (has("termguicolors"))
  set termguicolors
endif

" Customize fzf colors to match your color scheme
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

autocmd FileType go   call SetGoOptions()
autocmd FileType json call SetJsonOptions()
autocmd FileType vim  call SetVimOptions()

highlight Normal guibg=none
highlight NonText guibg=none
