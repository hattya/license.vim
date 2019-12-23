" File:        autoload/license.vim
" Author:      Akinori Hattori <hattya@gmail.com>
" Last Change: 2019-12-23
" License:     MIT License

let s:save_cpo = &cpo
set cpo&vim

let s:L = vital#license#import('Data.List')
let s:V = vital#license#import('Prelude')
let s:TOML = vital#license#import('Text.TOML')
let s:G = vital#license#import('Vim.Guard')

let s:license = {
\  'name': '',
\  'text': '',
\  'wrap': 1,
\}

function! license#license(line1, line2, bang, name) abort
  try
    let lic = license#load(a:name)
  catch
    return s:error(v:exception)
  endtry
  let last = line('$')
  let line1 = max([a:line1, 0])
  let line2 = min([a:line2, last + 1])

  let g = s:G.store(['&l:formatoptions', '&l:textwidth'])
  let pos = getpos('.')
  try
    setlocal formatoptions+=tco
    call cursor(max([line1, 1]), 1)
    " insert
    if a:bang
      execute "normal! o_\<BS>"
      let ind = matchstr(getline('.'), '\s\+$')
      silent delete _
      normal! k
      let wrap = 0
      if !lic.wrap
        setlocal textwidth=0
      endif
    else
      let sw = license#shiftwidth()
      let ind = repeat(' ', sw)
      let tw = license#getvar('license_textwidth', &textwidth)
      let wrap = tw > 0 && lic.wrap
      setlocal textwidth=0
    endif
    if line1 == 0
      normal! O
    endif
    for s in split(lic.text, '\r\=\n')
      normal! o
      if s =~# '^\s*$'
        continue
      endif
      let l = getline('.')
      if wrap
        let &l:textwidth = (l !=# '' ? len(l) + sw : 0) + tw
      endif
      execute 'normal! a' . (l !=# '' ? ind : '') . s
    endfor
    " delete
    if line1 == line2
      if line1 == 0
        silent 1 delete _
      endif
    elseif line1 < line2
      if line1 < last
        execute printf('silent .+1,.+%d delete _', min([line2, last]) - line1)
      endif
      execute printf('silent %d delete _', line1)
    endif
  finally
    call setpos('.', pos)
    call g.restore()
  endtry
endfunction

function! license#name(...) abort
  if !&modified
    return
  endif

  let name = get(a:000, 0, '')
  let last = line('$')

  let pos = getpos('.')
  try
    let pre = license#getvar('license_keyword_pre', '\cLicense:')
    let post = license#getvar('license_keyword_post', '$')
    let pat = pre .'\s*\zs\ze' . post
    let lines = license#getvar('license_lines', 10)
    let lic = {}
    for lnum in [1, max([last - lines, lines]) + 1]
      let stopline = min([lnum + lines - 1, last])
      while lnum <= stopline
        call cursor(lnum, 1)
        let lnum = search(pat, 'cW', stopline)
        if lnum == 0
          break
        elseif empty(lic)
          if name ==# ''
            let name = s:input()
            if name ==# ''
              return
            endif
          endif
          try
            let lic = license#load(name)
          catch
            return s:error(v:exception)
          endtry
        endif
        call setline(lnum, substitute(getline(lnum), pat, lic.name, ''))
        let lnum += 1
      endwhile
    endfor
  finally
    call setpos('.', pos)
  endtry
endfunction

function! license#shiftwidth() abort
  return license#getvar('license_shiftwidth', 1)
endfunction

function! license#getvar(name, ...) abort
  return get(b:, a:name, get(g:, a:name, a:0 > 0 ? a:1 : 0))
endfunction

function! s:error(msg) abort
  redraw
  echohl ErrorMsg
  echomsg 'license: ' . a:msg
  echohl None
endfunction

function! s:input() abort
  echohl Question
  let s = input('License: ', '', 'customlist,license#complete')
  echohl None
  return s
endfunction

function! license#load(name) abort
  let name = s:trim(a:name)
  let files = s:find(name)
  if empty(files)
    throw 'license not found: ' . name
  endif
  try
    let lic = get(s:TOML.parse_file(files[-1]), 'license', {})
  catch
    throw substitute(v:exception, '\v^%(\S+:\s+){2}(\u)', '\l\1', '')
  endtry
  if empty(lic)
    throw 'empty license: ' . name
  endif
  return extend(copy(s:license), lic)
endfunction

function! license#complete(lead, line, pos) abort
  let list = []
  for f in s:find(a:lead . (a:lead =~# '\*$' ? '' : '*'))
    call add(list, fnamemodify(f, ':t:r'))
  endfor
  return sort(s:L.uniq_by(list, 'tolower(v:val)'))
endfunction

function! s:find(name) abort
  let n = substitute(a:name, '\v(\a)', '[\u\1\l\1]', 'g')
  return s:V.globpath(&runtimepath, 'license/' . n . '.toml')
endfunction

function! s:trim(s) abort
  return matchstr(a:s, '\v^\s*\zs.{-}\ze\s*$')
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
