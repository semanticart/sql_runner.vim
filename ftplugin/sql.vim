nnoremap <buffer> <localleader>r :call RunSQLFile()<cr>

function! RunSQLFile()
  " Save any changes to our sql file
  silent update

  let l:cmd = g:sql_runner_cmd . ' -f ' . expand('%')
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

  " Clear out the existing content
  normal! gg"_dG

  " Don't prompt to save the results buffer
  set buftype=nofile

  " Insert the results
  call append(0, l:results)

  " Return focus to the sql query window
  execute 'wincmd p'
endfunction
