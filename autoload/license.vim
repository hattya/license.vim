" File:        autoload/license.vim
" Author:      Akinori Hattori <hattya@gmail.com>
" Last Change: 2016-04-30
" License:     MIT License

let s:save_cpo = &cpo
set cpo&vim

let s:L = vital#license#import('Data.List')
let s:TOML = vital#license#import('Text.TOML')
let s:G = vital#license#import('Vim.Guard')

let s:license = {
\  'name': '',
\  'text': '',
\  'wrap': 1,
\}

function! license#license(name, line1, line2) abort
  try
    let lic = license#load(a:name)
  catch
    return s:error(v:exception)
  endtry
  let line1 = max([a:line1, 1])
  let line2 = min([a:line2, line('$')])

  let g = s:G.store('&l:formatoptions', '&l:textwidth')
  let pos = getpos('.')
  try
    setlocal formatoptions+=tco
    call cursor(line1, 1)
    " insert
    let sw = s:getvar('license_shiftwidth', 1)
    let ind = repeat(' ', sw)
    let tw = s:getvar('license_textwidth', &textwidth)
    let wrap = 0 < tw && lic.wrap
    setlocal textwidth=0
    if a:line1 == 0
      normal! O
      normal! k
    endif
    for s in split(lic.text, '\n')
      normal! o
      if s =~# '^\s*$'
        continue
      endif
      let l = substitute(getline('.'), '\s\+$', '', '')
      if wrap
        let &l:textwidth = (l !=# '' ? len(l) + sw : 0) + tw
      endif
      execute 'normal! a' . (l !=# '' ? ind : '') . s
    endfor
    " delete
    if a:line1 == a:line2
      if a:line1 == 0
        silent! 1delete _
      endif
    elseif a:line1 < a:line2
      execute printf('silent! .+1,+%ddelete _', line2 - a:line1)
      execute printf('silent! %ddelete _', line1)
    endif
  finally
    call setpos('.', pos)
    call g.restore()
  endtry
endfunction

function! s:getvar(name, ...) abort
  return get(b:, a:name, get(g:, a:name, 0 < a:0 ? a:1 : 0))
endfunction

function! s:error(msg) abort
  redraw
  echohl ErrorMsg
  echomsg 'license: ' . a:msg
  echohl None
endfunction

function! license#load(name) abort
  let files = s:find(a:name)
  if empty(files)
    throw 'license not found: ' . a:name
  endif
  try
    let lic = get(s:TOML.parse_file(files[0]), 'license', {})
  catch
    throw substitute(v:exception, '\v^%(\S+:\s+){2}(\u)', '\l\1', '')
  endtry
  if empty(lic)
    throw 'empty license: ' . a:name
  endif
  return extend(copy(s:license), lic)
endfunction

function! license#complete(arg, line, pos) abort
  let list = []
  for f in s:find(a:arg . (a:arg =~# '\*$' ? '' : '*'))
    call add(list, fnamemodify(f, ':t:r'))
  endfor
  return sort(s:L.uniq_by(list, 'tolower(v:val)'))
endfunction

function! s:find(name) abort
  let n = substitute(a:name, '\v(\a)', '[\u\1\l\1]', 'g')
  return split(globpath(&runtimepath, 'license/' . n . '.toml', 1), '\n')
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
