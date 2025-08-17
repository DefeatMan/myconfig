vim9script

set nocompatible

call plug#begin('~/.vim/plugged')

Plug 'preservim/nerdcommenter'
Plug 'skywind3000/asyncrun.vim'
# Plug 'skywind3000/asynctasks.vim'
Plug 'ojroques/vim-oscyank', {'branch': 'main'}
Plug 'w0rp/ale'
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'ycm-core/YouCompleteMe'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'vim-airline/vim-airline'
# Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug'] }
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && npx --yes yarn install' }
Plug 'morhetz/gruvbox'

call plug#end()

# Cursor
if &term =~ "xterm"
  # INSERT mode
  &t_SI = "\<Esc>[6 q" .. "\<Esc>]12;white\x7"
  # REPLACE mode
  &t_SR = "\<Esc>[3 q" .. "\<Esc>]12;white\x7"
  # NORMAL mode
  &t_EI = "\<Esc>[2 q" .. "\<Esc>]12;green\x7"
endif

# WinExit
noremap <C-c> :bd<CR>
noremap cc :bp<bar>bd #<CR>

# GitDiff
noremap <leader>c :qa<CR>
noremap <leader>q :cq<CR>

# Scheme
colorscheme gruvbox
set bg=dark
g:gruvbox_contrast_dark = 'hard'

# Airbar
g:airline_section_b = '%{strftime("%H:%M")}'

# Settings
set encoding=utf-8
set mouse=nicr
set hlsearch
set incsearch
set nu rnu
set ignorecase
set smartcase
set ts=2
set shiftwidth=2
set softtabstop=2
set expandtab
set autoindent

# Clang-Format
g:my_clang_format_script = '/usr/share/clang/clang-format.py'

def g:CodeFmt()
  if &filetype == 'go'
    :w
    var ret = system("go fmt " .. expand('%'))
    :e|redraw!
    :echom ret
  else
    execute 'py3f ' .. g:my_clang_format_script
  endif
enddef

nnoremap <silent> mm :call CodeFmt()<CR>

func ClangFormatOnSave()
  let l:formatdiff = 1
  execute 'py3f ' .. g:my_clang_format_script
endfunc

augroup AUClangFormatOnSave
  au!
  au BufWritePre *.json,*.h,*.hpp,*.cc,*.cpp,*.cu call ClangFormatOnSave()
augroup END

# OSC-YANK
nmap <leader>y <Plug>OSCYankOperator
nmap <leader>yy <leader>y_
vmap <leader>y <Plug>OSCYankVisual

# FZF
# gitlab.com/saalen/highlight
nmap <C-p> :Files<CR>
nmap <C-e> :Buffers<CR>
nmap f :Ag<CR>
nmap F :exec "Ag " .. expand('<cword>')<CR>
nmap t :BTags<CR>
g:fzf_action = { 'ctrl-e': 'edit' }
command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>, {'options': ['--layout=reverse', '--info=inline', '--preview', 'highlight -O ansi {} || cat {}']}, <bang>0)

# YCM
g:ycm_add_preview_to_completeopt = 0
g:ycm_show_diagnostics_ui = 0
g:ycm_server_log_level = 'info'
g:ycm_min_num_identifier_candidate_chars = 2
g:ycm_collect_identifiers_from_comments_and_strings = 1
g:ycm_complete_in_comments = 1
g:ycm_complete_in_strings = 1
g:ycm_key_invoke_completion = '<c-z>'
g:ycm_global_ycm_extra_conf = '~/.vim/plugged/YouCompleteMe/.ycm_extra_conf.py'
g:ycm_confirm_extra_conf = 0
set completeopt=menu,menuone

noremap <c-z> <NOP>

g:ycm_semantic_triggers =  {
  \ 'rust,cuda,c,cpp,python,java,go,erlang,perl': ['re!\w{2}'],
  \ 'cs,lua,javascript,javascriptreact,typescript,typescriptreact': ['re!\w{2}'],
  \ 'kotlin': ['re!\w{2}'],
  \ }

g:ycm_filetype_whitelist = {
  \ "rust": 1,
  \ "typescript": 1,
  \ "typescriptreact": 1,
  \ "javascript": 1,
  \ "javascriptreact": 1,
  \ "python": 1,
  \ "kotlin": 1,
  \ "cuda": 1,
  \ "c": 1,
  \ "cpp": 1,
  \ "objc": 1,
  \ "go": 1,
  \ "sh": 1,
  \ "zsh": 1,
  \ "zimbu": 1,
  \ }

g:ycm_lsp_dir = expand('$HOME') .. "/ycm-lsp"

g:ycm_language_server = [
  \ {
  \   'name': 'jetbrains_kotlin',
  \   'cmdline': [
  \     '/usr/bin/env', 'JAVA_HOME=/usr/lib/jvm/java-17-openjdk/',
  \     expand( g:ycm_lsp_dir ) .. '/jetbrains_kotlin/kotlin-lsp/kotlin-lsp.sh',
  \     '--stdio',
  \   ],
  \   'filetypes': [ 'kotlin' ],
  \   'project_root_files': [ 'build.gradle', 'build.gradle.kts', 'pom.xml' ],
  \ },
  \ ]

nnoremap <leader>gl :YcmCompleter GoToDeclaration<CR>
nnoremap <leader>gf :YcmCompleter GoToDefinition<CR>
nnoremap <leader>gg :YcmCompleter GoToDefinitionElseDeclaration<CR>
nnoremap <leader>rn :YcmCompleter RefactorRename

# ALE
g:ale_linters_explicit = 1
g:ale_completion_delay = 500
g:ale_echo_delay = 20
g:ale_lint_delay = 500
g:ale_echo_msg_format = '[%linter%] %code: %%s'
g:ale_lint_on_text_changed = 'normal'
g:ale_lint_on_insert_leave = 1
g:airline#extensions#ale#enabled = 1

g:ale_c_gcc_options = '-Wall -O2 -std=c2x'
g:ale_cpp_gcc_options = '-Wall -O2 -std=c++23'
g:ale_c_cppcheck_options = ''
g:ale_cpp_cppcheck_options = ''

g:ale_sign_error = "\ue009\ue009"
hi! clear SpellBad
hi! clear SpellCap
hi! clear SpellRare
hi! SpellBad gui=undercurl guisp=red
hi! SpellCap gui=undercurl guisp=blue
hi! SpellRare gui=undercurl guisp=magenta

g:asyncrun_bell = 1

g:asyncrun_rootmarks = [ '.svn', '.git', '.root', '_darcs', 'build.xml' ]

g:asyncrun_open = 12

g:asyncrun_save = 1

def g:CompileBuild()
  exec "w"
  if &filetype == 'c'
    exec ':AsyncRun gcc "$(VIM_FILEPATH)" -o "$(VIM_FILEDIR)/$(VIM_FILENOEXT)"'
  elseif &filetype == 'cpp'
    exec ':AsyncRun g++ -Wall -O2 "$(VIM_FILEPATH)" -o "$(VIM_FILEDIR)/$(VIM_FILENOEXT)" -lstdc++ -std=c++23'
  elseif &filetype == 'go'
    exec ":AsyncRun go build $(VIM_FILEDIR)/$(VIM_FILENOEXT)"
  endif
enddef
noremap <silent> <F9> :call CompileBuild()<CR>

def g:CompileRun()
  exec "w"
  if &filetype == 'c'
    exec ":AsyncRun -raw $(VIM_FILEDIR)/$(VIM_FILENOEXT)"
  elseif &filetype == 'cpp'
    exec ":AsyncRun -raw $(VIM_FILEDIR)/$(VIM_FILENOEXT)"
  elseif &filetype == 'python'
    exec ":AsyncRun -raw python3 $(VIM_FILEPATH)"
  elseif &filetype == 'go'
    exec ":AsyncRun -raw go run $(VIM_FILEPATH)"
  elseif &filetype == 'javascript'
    exec ":AsyncRun -raw node $(VIM_FILEPATH)"
  endif
enddef
noremap <silent> <F10> :call CompileRun()<CR>

def g:CompileRunInTerminal()
  exec "w"
  if &filetype == 'c'
    exec ":AsyncRun -mode=term -raw $(VIM_FILEDIR)/$(VIM_FILENOEXT)"
  elseif &filetype == 'cpp'
    exec ":AsyncRun -mode=term -raw $(VIM_FILEDIR)/$(VIM_FILENOEXT)"
  elseif &filetype == 'python'
    exec ":AsyncRun -mode=term -raw python3 $(VIM_FILEPATH)"
  elseif &filetype == 'go'
    exec ":AsyncRun -mode=term -raw go run $(VIM_FILEPATH)"
  elseif &filetype == 'javascript'
    exec ":AsyncRun -mode=term -raw node $(VIM_FILEPATH)"
  endif
enddef
noremap <silent> <F8> :call CompileRunInTerminal()<CR>

nnoremap <F5> :call asyncrun#quickfix_toggle(12)<CR>

def g:GitBlame()
  var li = line('.')
  exec ":AsyncRun -raw git blame -L " .. li .. ",+8 $(VIM_FILEPATH)"
enddef

nnoremap <silent> <leader>b :call GitBlame()<CR>

# ProgKeep
set viminfo='100,<1000,s100,h
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
