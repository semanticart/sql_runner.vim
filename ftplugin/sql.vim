nnoremap <buffer> <localleader>r :call sql_runner#RunSQLFile()<cr>
nnoremap <buffer> <localleader>d :call sql_runner#DescribeTable()<cr>
command! -nargs=1 DescribeTable call sql_runner#DescribeTable(<q-args>)
nnoremap <buffer> <localleader>D :DescribeTable<space>
