set nocompatible

" Need to set the leader before defining any leader mappings
let mapleader = "\<Space>"

function! s:SourceConfigFilesIn(directory)
  let directory_splat = '~/.vim/' . a:directory . '/*'
  for config_file in split(glob(directory_splat), '\n')
    if filereadable(config_file)
      execute 'source' config_file
    endif
  endfor
endfunction

" Load plugins
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
call s:SourceConfigFilesIn('rcplugins')
call vundle#end()
filetype off
filetype plugin indent on

" Load vim custom configurations
call s:SourceConfigFilesIn('rcfiles')

syntax on

" vim:ft=vim
