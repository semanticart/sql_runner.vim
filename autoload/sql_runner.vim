function! <SID>Strip(string)
  return substitute(a:string, '^\s*\(.\{-}\)\s*$', '\1', '')
endfunction

function! <SID>ParseTableResult(line)
  return s:Strip(split(a:line, '|')[1])
endfunction

function! sql_runner#ListTableNames(arg_lead, cmd_line, cursor_pos)
  " get the table names
  let l:tables = s:RunSQLCommand(' -c "\dt ' . a:arg_lead . '*"')

  return map(tables[3:-3], 's:ParseTableResult(v:val)')
endfunction

function! sql_runner#DescribeTable(...)
  if a:0 == 0
    let table = expand("<cword>")
  else
    let table = a:1
  endif
  call s:RunAndDisplaySQLCommand(' -c "\d+ '. table . '"')
endfunction

function! sql_runner#RunSQLFile(...)
  let l:file = get(a:, 1, expand('%'))
  call s:RunAndDisplaySQLCommand(' -f ' . l:file)
endfunction

function! <SID>RunSQLCommand(cmd)
  let l:cmd = g:sql_runner_cmd . a:cmd
  return systemlist(l:cmd)
endfunction

function! <SID>RunAndDisplaySQLCommand(cmd)
  " Save any changes to our sql file
  silent update

  let l:results = s:RunSQLCommand(a:cmd)

  " Create a split with a meaningful name
  let l:name = '__SQL_Results__'

  if bufwinnr(l:name) == -1
    " Open a new split
    execute 'vsplit ' . l:name
  else
    " Focus the existing window
    execute bufwinnr(l:name) . 'wincmd w'
  endif

  " Remember our position in the results window
  let l:pos = getpos('.')

  " Clear out the existing content
  normal! gg"_dG

  " Don't prompt to save the results buffer
  set buftype=nofile

  " Insert the results
  call append(0, l:results)

  " Jump back to our original position in the results window
  call setpos('.', l:pos)

  nnoremap <buffer> q :bd<CR>

  " Return focus to the sql query window
  execute 'wincmd p'
endfunction
