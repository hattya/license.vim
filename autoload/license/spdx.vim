" File:        autoload/license/spdx.vim
" Author:      Akinori Hattori <hattya@gmail.com>
" Last Change: 2020-10-08
" License:     MIT License

let s:save_cpo = &cpo
set cpo&vim

let s:V = vital#license#import('Prelude')
let s:G = vital#license#import('Vim.Guard')

let s:ops = ['AND', 'OR', 'WITH']
let s:list = ['SPDX.licenses', 'SPDX.exceptions']

function! license#spdx#license(line1, line2, expr) abort
  let line = max([a:line1, a:line2, 0])

  let g = s:G.store(['&l:formatoptions'])
  let pos = getpos('.')
  try
    setlocal formatoptions+=o
    call cursor(max([line, 1]), 1)
    " insert
    execute 'normal! ' . (line == 0 ? 'O' : 'o')
    execute 'normal! a' . (getline('.') !~# '^\s*$' ? repeat(' ', license#shiftwidth()) : '') . 'SPDX-License-Identifier: ' . a:expr
  finally
    call setpos('.', pos)
    call g.restore()
  endtry
endfunction

function! license#spdx#complete(lead, line, pos) abort
  let pfx = matchstr(a:lead, '^.*[()[:space:]]')
  if a:pos > 0 && a:lead !=# a:line[: a:pos-1]
    " for :command
    let lead = a:lead[len(pfx) :]
    let args = s:split(a:line[: a:pos-1])[1 : lead !=# '' ? -2 : -1]
  else
    " for input()
    let lead = a:pos > 0 ? a:line[len(pfx) : a:pos-1] : ''
    let args = s:split(pfx)
  endif

  let list = len(args) % 2 != 0 ? copy(s:ops)[: s:is_with(args, -2) ? -2 : -1] : s:load(s:list[s:is_with(args, -1)])
  return map(filter(list, "v:val =~? '^" . lead . "'"), 'pfx . v:val')
endfunction

function! s:is_with(list, i) abort
  return len(a:list) >= -a:i && a:list[a:i] ==? 'WITH'
endfunction

function! s:load(name) abort
  let list = map(readfile(s:V.globpath(&runtimepath, 'license/' . a:name)[-1]), 'split(v:val)')

  let spdx = license#getvar('spdx_license', [])
  let expr = []
  if index(spdx, 'deprecated') == -1
    call add(expr, 'index(v:val, "deprecated") == -1')
  endif
  for v in ['fsf', 'osi']
    if index(spdx, v) != -1
      call add(expr, 'index(v:val, "' . v . '") != -1')
    endif
  endfor
  if !empty(expr)
    call filter(list, join(expr, ' && '))
  endif

  return map(list, 'v:val[0]')
endfunction

function! s:split(s) abort
  return split(a:s, '[()[:space:]]\+')
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
