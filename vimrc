" vim: foldmethod=marker

""""""""""" Useful links {{{1
" http://vimcasts.org
" https://danielmiessler.com/study/vim/
" https://stevelosh.com/blog/2010/09/coming-home-to-vim/
""""""""""" Useful links }}}1

""""""""""" General settings {{{1
silent! helptags ALL  " Generate all helptags
let mapleader = "\<Space>"
color elflord

syntax enable
filetype plugin indent on
set encoding=utf-8
set fileencoding=utf-8
set nrformats-=octal  " don't assume numbers are octal for ctrl-a, ctrl-x
set mouse=a

" episode 2 http://vimcasts.org/episodes/tabs-and-spaces/
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
" episode 3 http://vimcasts.org/episodes/whitespace-preferences-and-filetypes/
augroup file_whitespace
  autocmd!
  autocmd FileType ruby setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
  autocmd FileType python setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab
augroup end

" set path to automatically search all subdirectories
set path+=./**
" https://gist.github.com/csswizardry/9a33342dace4786a9fee35c73fa5deeb
" Show file options above the command line
set wildmenu
set wildmode=list:full
" Don't offer to open certain files/directories
set wildignore+=*.bmp,*.gif,*.ico,*.jpg,*.png,*.ico
set wildignore+=*.pdf,*.psd
set wildignore+=node_modules/*,bower_components/*,.git/*

set autoindent
set showmode
set showcmd
set visualbell
set ruler
set laststatus=2  " Always show last status
set ignorecase
set smartcase
set gdefault
set incsearch
set showmatch
set hlsearch

" Change window split behavior
set splitright
set splitbelow

" Set up persistent undo
if has("persistent_undo")
	set undodir=~/.vim/undodir
	set undofile
  silent! call system('mkdir -p ' . &undodir)
endif

" WSL yank support
" https://superuser.com/a/1557751
let s:clip = '/c/Windows/System32/clip.exe'
if executable(s:clip)
    augroup WSLYank
        autocmd!
        autocmd TextYankPost * if v:event.operator ==# 'y' | call system(s:clip, @0) | endif
    augroup END

    " let s:paste = '/c/WINDOWS/System32/WindowsPowerShell/v1.0/powershell.exe -command "Get-Clipboard"'

    " https://stackoverflow.com/questions/9458294/open-url-under-cursor-in-vim-with-browser
    let g:netrw_browsex_viewer="cmd.exe /C start" 

    " Install fzf for windows (assume it is installed via git)
    set rtp+=~/.fzf

    " https://github.com/Microsoft/WSL/issues/2183#issuecomment-315881809
    " fix mouse in windows
    set ttymouse=sgr
endif
""""""""""" General settings }}}1

""""""""""" Visual settings {{{1
set nowrap
set number 

" reveal neighbor text when nearing screen borders
set scrolloff=1
set sidescrolloff=5
" set listchars=tab:▸\ ,eol:¬
set statusline=%f         " Path to the file
set statusline+=\ \      " Separator
set statusline+=%{FugitiveStatusline()}  " Git Branch
set statusline+=%=        " Switch to the right side
set statusline+=%y        " Filetype of the file
set statusline+=\ -\      " Separator
set statusline+=%l        " Current line
set statusline+=/         " Separator
set statusline+=%L        " Total lines

" https://vi.stackexchange.com/a/10898
" https://stackoverflow.com/a/17183382
" https://vim.fandom.com/wiki/Xterm256_color_names_for_console_Vim
hi DiffAdd      cterm=none ctermfg=10 ctermbg=22 gui=none guifg=NONE guibg=#bada9f
hi DiffChange   cterm=none ctermfg=10 ctermbg=17 gui=none guifg=NONE guibg=#e5d5ac
hi DiffDelete   cterm=bold ctermfg=10 ctermbg=1 gui=bold guifg=#ff8080 guibg=#ffb0b0
hi DiffText     cterm=none ctermfg=10 ctermbg=20 gui=none guifg=NONE guibg=#8cbee2

" highlight DiffAdd    cterm=bold ctermfg=10 ctermbg=17 gui=none guifg=bg guibg=Red
" highlight DiffDelete cterm=bold ctermfg=10 ctermbg=17 gui=bold guifg=bg guibg=Red
" highlight DiffChange cterm=bold ctermfg=10 ctermbg=17 gui=none guifg=bg guibg=Red
" highlight DiffText   cterm=bold ctermfg=10 ctermbg=88 gui=none guifg=bg guibg=Red

""""""""""" Visual settings }}}1

""""""""""" Mappings {{{1
inoremap jk <ESC>
nnoremap <leader>w :set wrap!<cr>
nnoremap <leader>n :set relativenumber!<cr>

" Shortcut to launch netrw
let g:netrw_liststyle = 3
nnoremap <leader>f :20Lexplore<cr>

" episode 1 http://vimcasts.org/episodes/show-invisibles/
nnoremap <leader>l :set list!<cr>
" episode 4 http://vimcasts.org/episodes/tidying-whitespace/
nnoremap <silent> <leader>s :call <SID>StripTrailingWhitespaces()<cr>
function! <SID>StripTrailingWhitespaces()
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " Do the business:
    %s/\s\+$//e
    " Clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction

nnoremap <leader>h :set hlsearch!<cr>
" Undotree plugin for visualizing undo branches
nnoremap <leader>u :UndotreeToggle<CR>

" Shortcut to documents
nnoremap <leader>ed :tabe /home/ed/personal/documentation/notes.txt<cr>
nnoremap <leader>em :tabe /home/ed/personal/src/dotfiles/manjaro-kde.sh<cr>

" https://learnvimscriptthehardway.stevelosh.com/chapters/32.html
" grep the word under the cursor in all subfolders
nnoremap <leader>g :silent execute "grep! -iIEr --exclude-dir env " . shellescape(expand("<cword>")) . " ."<cr>:copen<cr><C-l>
nnoremap <leader>G :silent execute "grep! -iIEr --exclude-dir env " . shellescape(expand("<cWORD>")) . " ."<cr>:copen<cr><C-l>

" Shortcut to .vimrc
" http://learnvimscriptthehardway.stevelosh.com/chapters/07.html
nnoremap <expr> <leader>ev ':tabe ' . resolve($MYVIMRC) . '<cr>'
nnoremap <leader>sv :source $MYVIMRC<cr>

nnoremap <leader>eg :tabe ~/.config/git/ignore<cr>

nnoremap <leader>" viw<esc>a"<esc>bi"<esc>lel
nnoremap <leader>' viw<esc>a'<esc>bi'<esc>lel

" Window navigation shortcuts
" https://vim.fandom.com/wiki/Get_Alt_key_to_work_in_terminal
set <M-h>=h
set <M-j>=j
set <M-k>=k
set <M-l>=l
nnoremap <M-h> <C-w>h
nnoremap <M-j> <C-w>j
nnoremap <M-k> <C-w>k
nnoremap <M-l> <C-w>l
tnoremap <M-h> <C-w>h
tnoremap <M-j> <C-w>j
tnoremap <M-k> <C-w>k
tnoremap <M-l> <C-w>l

" Autocompletion shortcuts, see :help ins-comp
inoremap <C-]> <C-x><C-]>
inoremap <C-f> <C-x><C-f>
inoremap <C-d> <C-x><C-d>
inoremap <C-l> <C-x><C-l>

tnoremap jk <C-\><C-n>
tnoremap <C-r> <C-w>"

""""""""""" Plugin Mappings {{{2
nmap <leader>ad :LSClientDisable<cr>
nmap <leader>ae :LSClientEnable<cr>
nmap <leader>at <Plug>(ale_toggle)
nmap <leader>ap <Plug>(ale_previous_wrap)
nmap <leader>an <Plug>(ale_next_wrap)
""""""""""" Plugin Mappings }}}2
""""""""""" Mappings }}}1

""""""""""" Plugin config {{{1
" https://github.com/hashivim/vim-terraform
let g:terraform_align=1
let g:terraform_fmt_on_save=1
" let g:terraform_fold_sections=1

" https://github.com/natebosch/vim-lsc/wiki/Language-Servers
" https://github.com/golang/tools/blob/master/gopls/doc/vim.md#vim-lsc
let g:lsc_auto_map = v:true
let g:lsc_server_commands = {
      \  "python" : "pyls",
      \  "go": {
      \    "command": "gopls serve",
      \    "log_level": -1,
      \    "suppress_stderr": v:true,
      \  },
      \  "terraform": {
      \    "command": "/home/ed/personal/src/cicdmanager/terraform/remote-state/tf-spy.sh",
      \    "log_level": -1,
      \    "suppress_stderr": v:true,
      \  }
      \}

let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'python': ['black', 'isort'],
\}

" Default run command for scripts
augroup run_shortcuts
  autocmd!
  autocmd FileType python3 nnoremap <leader>r :!python3 %<cr>
  autocmd FileType python3 nnoremap <leader>d :!python3 -m pdb %<cr>

  autocmd FileType c nnoremap <leader>r :!gcc % -o %:r.o; ./%:r.o <cr>
  autocmd FileType arduino nnoremap <leader>r :!gcc % -o %:r.o; ./%:r.o <cr>
augroup END
""""""""""" Plugin config }}}1
