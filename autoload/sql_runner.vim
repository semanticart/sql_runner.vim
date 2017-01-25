function! sql_runner#DescribeTable(...)
  if a:0 == 0
    let table = expand("<cword>")
  else
    let table = a:1
  endif
  call s:RunSQLCommand(' -c "\d+ '. table . '"')
endfunction

function! sql_runner#RunSQLFile()
  call s:RunSQLCommand(' -f ' . expand('%'))
endfunction

function! <SID>RunSQLCommand(cmd)
  " Save any changes to our sql file
  silent update

  let l:cmd = g:sql_runner_cmd . a:cmd
  let l:results = systemlist(l:cmd)

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

  " Return focus to the sql query window
  execute 'wincmd p'
endfunction
