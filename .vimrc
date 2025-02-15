vim9script

set nocompatible

call plug#begin('~/.vim/plugged')

Plug 'preservim/nerdcommenter'
Plug 'ludovicchabant/vim-gutentags'
Plug 'skywind3000/asyncrun.vim'
Plug 'ojroques/vim-oscyank', {'branch': 'main'}
Plug 'w0rp/ale'
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'ycm-core/YouCompleteMe'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'vim-airline/vim-airline'
# Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug'] }
# Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && npx --yes yarn install' }
Plug 'morhetz/gruvbox'
# Plug 'github/copilot.vim'

call plug#end()

map ;y : !/mnt/c/Windows/System32/clip.exe<cr>u

g:airline_section_b = '%{strftime("%H:%M")}'

if &term =~ "xterm"
    # INSERT mode
    &t_SI = "\<Esc>[6 q" .. "\<Esc>]12;white\x7"
    # REPLACE mode
    &t_SR = "\<Esc>[3 q" .. "\<Esc>]12;white\x7"
    # NORMAL mode
    &t_EI = "\<Esc>[2 q" .. "\<Esc>]12;green\x7"
endif

colorscheme gruvbox

noremap <C-c> :bd<CR>
noremap cc :bp<bar>bd #<CR>

set encoding=utf-8
set bg=dark
g:gruvbox_contrast_dark = 'hard'

set hlsearch
set incsearch
set nu rnu
set ignorecase
set smartcase
set ts=2            # 设置缩进为4个空格
set shiftwidth=2    # 表示每一级缩进的长度
set softtabstop=2   # 退格键退回缩进空格的长度
set expandtab       # 设置缩进用空格表示
set autoindent      # 自动缩进

# Github Copilot
# g:copilot_not_tab_map = v:true
# g:copilot_enabled  = v:false
# imap <silent><script><expr> j copilot#Accept("\<CR>")
# imap q <Plug>(copilot-suggest)
# imap k <Plug>(copilot-accept-word)
# imap l <Plug>(copilot-accept-line)
# imap ] <Plug>(copilot-next)
# imap [ <Plug>(copilot-previous)

# OSC-YANK
nmap <leader>c <Plug>OSCYankOperator
nmap <leader>cc <leader>c_
vmap <leader>c <Plug>OSCYankVisual

# FZF vim
nmap <C-p> :Files<CR>
nmap <C-e> :Buffers<CR>
nmap f :Ag<CR>
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
g:ycm_complete_in_strings = 1
g:ycm_key_invoke_completion = '<c-z>'
g:ycm_global_ycm_extra_conf = '~/.vim/plugged/YouCompleteMe/.ycm_extra_conf.py'
g:ycm_confirm_extra_conf = 0
set completeopt=menu,menuone

noremap <c-z> <NOP>

g:ycm_semantic_triggers =  {
           \ 'c,cpp,python,java,go,erlang,perl': ['re!\w{2}'],
           \ 'cs,lua,javascript': ['re!\w{2}'],
           \ }

g:ycm_filetype_whitelist = {
      \ "python": 1,
      \ "c": 1,
      \ "cpp": 1,
      \ "objc": 1,
      \ "go": 1,
      \ "sh": 1,
      \ "zsh": 1,
      \ "zimbu": 1,
      \ }

g:ycm_language_server =
            \ [
            \   {
            \       'name': 'ccls',
            \       'cmdline': [ 'ccls' ],
            \       'filetypes': [ 'c', 'cpp', 'objc', 'objcpp' ],
            \       'project_root_files': [ '.ccls-root', 'compile_commands.json' ]
            \   },
            \ ]

nnoremap <leader>gl :YcmCompleter GoToDeclaration<CR>
nnoremap <leader>gf :YcmCompleter GoToDefinition<CR>
nnoremap <leader>gg :YcmCompleter GoToDefinitionElseDeclaration<CR>

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

# 任务结束时候响铃提醒
g:asyncrun_bell = 1

g:asyncrun_rootmarks = [ '.svn', '.git', '.root', '_darcs', 'build.xml' ]

# 自动打开高度为具体值的 quickfix 窗口
g:asyncrun_open = 12
# 运行前保存文件
g:asyncrun_save = 1
# 用<F9>编译
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
noremap <silent> <F9> :call CompileBuild()<cr>

# 用<F5>运行
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
noremap <silent> <F10> :call CompileRun()<cr>

# 设置 F5 打开/关闭 Quickfix 窗口
nnoremap <F5> :call asyncrun#quickfix_toggle(12)<cr>
nnoremap <silent> <F7> :AsyncRun -cwd=<root> make <cr>
nnoremap <silent> <F8> :AsyncRun -cwd=<root> -raw make run <cr>
nnoremap <silent> <F4> :AsyncRun -cwd=<root> cmake . <cr>

# ctags
# ctags --fields=+niazS --extras=+qF --kinds-c++=+pxl --kinds-c=+pxl -I \"_GLIBCXX_NOEXCEPT _GLIBCXX_USE_NOEXCEPT _GLIBCXX_NOTHROW _GLIBCXX_USE_CONSTEXPR _GLIBCXX_BEGIN_NAMESPACE_CONTAINER _GLIBCXX_END_NAMESPACE_CONTAINER _GLIBCXX_CONSTEXPR _GLIBCXX_NAMESPACE_LDBL _GLIBCXX_BEGIN_NAMESPACE_VERSION _GLIBCXX_END_NAMESPACE_VERSION _GLIBCXX_VISIBILITY+" -R -f ~/.vim/systags /usr/include/
# ctags --fields=+niazS --extras=+qF --kinds-python=+l -R -f ~/.vim/pytags /usr/lib/python3.11
set tags=./.tags;,.tags
set tags+=~/.vim/systags
set tags+=~/.vim/pytags

# gutentags 搜索工程目录的标志，碰到这些文件/目录名就停止向上一级目录递归
g:gutentags_project_root = ['.root', '.svn', '.git', '.hg', '.project']

# 所生成的数据文件的名称
g:gutentags_ctags_tagfile = '.tags'

# 将自动生成的 tags 文件全部放入 ~/.cache/tags 目录中，避免污染工程目录
var vim_tags = expand('~/.cache/tags')
g:gutentags_cache_dir = vim_tags

# 配置 ctags 的参数
g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extras=+qF']
g:gutentags_ctags_extra_args += ['--kinds-c++=+pxl']
g:gutentags_ctags_extra_args += ['--kinds-c=+pxl']
g:gutentags_ctags_extra_args += ['--kinds-python=+l']

# 检测 ~/.cache/tags 不存在就新建
if !isdirectory(vim_tags)
   silent! call mkdir(vim_tags, 'p')
endif

# clang-format
nnoremap mm :py3f /usr/share/clang/clang-format-14/clang-format.py<cr>

func Formatonsave()
  let l:formatdiff = 1
  py3f /usr/share/clang/clang-format.py
endfunc

augroup myautoload
    autocmd!
    autocmd BufWritePre *.json,*.h,*.hpp,*.cc,*.cpp call Formatonsave()
augroup END
