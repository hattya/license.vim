" File:        plugin/license.vim
" Author:      Akinori Hattori <hattya@gmail.com>
" Last Change: 2019-04-07
" License:     MIT License

if exists('g:loaded_license')
  finish
endif
let g:loaded_license = 1

let s:save_cpo = &cpo
set cpo&vim

command! -nargs=1 -complete=customlist,license#complete      -range=0 License     call license#license(<q-args>, <line1>, <line2>)
command! -nargs=1 -complete=customlist,license#spdx#complete -range=0 SPDXLicense call license#spdx#license(<q-args>, <line1>, <line2>)

augroup license
  autocmd!
  autocmd BufWritePre * call license#name()
augroup END

let &cpo = s:save_cpo
unlet s:save_cpo
