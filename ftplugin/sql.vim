nnoremap <buffer> <localleader>r :call sql_runner#RunSQLFile()<cr>
nnoremap <buffer> <localleader>d :call sql_runner#DescribeTable()<cr>
command! -nargs=1 -complete=customlist,sql_runner#ListTableNames DescribeTable call sql_runner#DescribeTable(<f-args>)
nnoremap <buffer> <localleader>D :DescribeTable<space>
