nnoremap <buffer> <localleader>r :call RunSQLFile()<cr>
nnoremap <buffer> <localleader>d :call DescribeTable()<cr>
nnoremap <buffer> <localleader>D :DescribeTable 

function! DescribeTable(...)
  if a:0 == 0
    let table = expand("<cword>")
  else
    let table = a:1
  endif
  call s:RunSQLCommand(' -c "\d+ '. table . '"', 1)
endfunction

function! RunSQLFile()
  call s:RunSQLCommand(' -f ' . expand('%'), 0)
endfunction

function! <SID>RunSQLCommand(cmd, jumpToTop)
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

  " Clear out the existing content
  normal! gg"_dG

  " Don't prompt to save the results buffer
  set buftype=nofile

  " Insert the results
  call append(0, l:results)

  if a:jumpToTop
    normal! gg0
  endif

  " Return focus to the sql query window
  execute 'wincmd p'
endfunction
