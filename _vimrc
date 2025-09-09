source $HOME/.vimrc.base

" 代码折叠
nnoremap <space> @=((foldclosed(line('.')) < 0) ? 'zc' : 'zO')<CR>
nnoremap zo zO
nnoremap zz zc
nnoremap za zM

" support options key
silent! set macmeta

source $HOME/.vimrc.unimap
