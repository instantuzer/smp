source $VIMRUNTIME/defaults.vim

syntax on

colorscheme sorbet

 if &diff
     colorscheme habamax
 endif

 nnoremap <leader>c :let @/='\<' . expand('<cword>') . '\>'<CR>:echo searchcount().total . " matches"<CR>
"nnoremap <leader>c :let @/='\<' . expand('<cword>') . '\>'<CR>:set hlsearch<CR>:echo searchcount().total . " matches"<CR>

