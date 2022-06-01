vim.cmd("autocmd BufWritePre *.go :silent! lua require('go.format').gofmt()")
