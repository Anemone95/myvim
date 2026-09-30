" Vim-only editor options. Shared mappings/options live in ~/.vimrc.base.
set langmenu=none
" iMproved, required
set nocompatible

" Desc: tab
set smarttab
" TAB 切换为空格
set expandtab
" tab=4 个空格
set tabstop=4
" 根据前方代码判断缩进
set cindent shiftwidth=4 " set cindent on to autoinent when editing c/c++ file, with 4 shift width
" 特定参数改变缩进行为, see help cinoptions-values for more details
set cinoptions=>s,e0,n0,f0,{0,}0,^0,:0,=s,l0,b0,g0,hs,ps,ts,is,+s,c3,C0,0,(0,us,U0,w0,W0,m0,j0,)20,*30

" Desc: 缩进
" shift 四舍五入到tab 的倍数
set shiftround
" 下一行复制上一行缩进
set autoindent
" {} 开始时添加缩进
set smartindent

set showmatch " show matching paren
" allow backspacing over everything in insert mode
set backspace=indent,eol,start
" 补全时即使有一个写显式菜单，不自动选第一个
set completeopt=menuone,noselect
" 关闭系统警告声
set noeb
" 任意时刻使用鼠标
set mouse=a
" enable complete in command mode
set wildmenu
set cmdheight=1
" show the cursor position all the time
set ruler
" shortens messages to avoid 'press a key' prompt
set shortmess=aoOtTI
" do not redraw while executing macros (much faster)
set lazyredraw
" for easy browse last line with wrap text
set display+=lastline
" always have status-line
set laststatus=2
" allow to change buffer without saving
set hidden
" 当文件在外部被修改，自动更新该文件
set autoread
" make sure our terminal use 256 color
set termguicolors
set t_Co=256
" File encoding
set encoding=utf-8                                    " 设置gvim内部编码，默认不更改
set fileencodings=utf-8,ucs-bom,gbk,cp936,latin-1     "设置支持打开的文件的编码
" 默认在右边/下边打开新窗口
set splitright
set splitbelow
" 0 second to show the matching parent ( much faster )
set matchtime=0
" no autochchdir
set noacd

source $HOME/.vimrc.base

" 代码折叠
nnoremap <space> @=((foldclosed(line('.')) < 0) ? 'zc' : 'zO')<CR>
nnoremap zo zO
nnoremap zz zc
nnoremap za zM

" support options key
silent! set macmeta

source $HOME/.vimrc.unimap
