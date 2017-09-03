" Vim syntax file
" Language:    C++ Writer (CPPW)
" Maintainger: Robert Bocchino <bocchino@icloud.com>
" Last Change: September 2017
" License:     VIM license (:help license, replace vim by cppw.vim)

" Start with C++ syntax
if version < 600
   syntax clear
   so <sfile>:p:h/cpp.vim
elseif exists("b:current_syntax")
   finish
else
  runtime! syntax/cpp.vim
endif

setl cindent

" CPPW annotations
syn match cppwSpecial "^ *@[A-Za-z0-9_]\+"

hi def link cppwSpecial Special
