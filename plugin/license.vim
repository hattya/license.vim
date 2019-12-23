" File:        plugin/license.vim
" Author:      Akinori Hattori <hattya@gmail.com>
" Last Change: 2019-12-23
" License:     MIT License

if exists('g:loaded_license')
  finish
endif
let g:loaded_license = 1

let s:save_cpo = &cpo
set cpo&vim

command! -nargs=1 -complete=customlist,license#complete      -range=0 -bang License     call license#license(<line1>, <line2>, <bang>0, <q-args>)
command! -nargs=1 -complete=customlist,license#spdx#complete -range=0       SPDXLicense call license#spdx#license(<line1>, <line2>, <q-args>)

augroup license
  autocmd!
  autocmd BufWritePre * call license#name()
augroup END

let &cpo = s:save_cpo
unlet s:save_cpo
