vim.g.mapleader = " "

vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

vim.cmd([[nnoremap <silent> } :<C-u>execute "keepjumps norm! " . v:count1 . "}"<CR>]])
vim.cmd([[nnoremap <silent> { :<C-u>execute "keepjumps norm! " . v:count1 . "{"<CR>]])

vim.cmd([[nnoremap <silent> <C-j> :<C-u>execute "keepjumps norm! " . v:count1 . "}"<CR>]])
vim.cmd([[nnoremap <silent> <C-k> :<C-u>execute "keepjumps norm! " . v:count1 . "{"<CR>]])

vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set({"n", "v", "i"}, "<C-c>", "<Esc>")

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "C-z", "<nop>")
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)
vim.keymap.set("n", "<C-S-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-S-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set("n", ";w", ":update<CR>", { silent = true })
vim.keymap.set("n", ";f", "gg=G``:w<CR>", { silent = true })

-- window
vim.keymap.set('n', '<M-,>', ":wincmd w<CR>", { silent = true })
vim.keymap.set('n', '<M-0>', ":wincmd q<CR>", { silent = true })
vim.keymap.set('n', '<M-1>', ":wincmd o<CR>", { silent = true })
vim.keymap.set("n", "<M-2>", ":leftabove vsplit %<CR>", { silent = true })
vim.keymap.set("n", "<M-3>", ":leftabove split %<CR>", { silent = true })

-- debugger
vim.keymap.set("n", "<F5>", "<Cmd>lua require'dap'.continue()<CR>", { silent = true })
vim.keymap.set("n", "<F10>", "<Cmd>lua require'dap'.step_over()<CR>", { silent = true })
vim.keymap.set("n", "<F11>", "<Cmd>lua require'dap'.step_into()<CR>", { silent = true })
vim.keymap.set("n", "<F12>", "<Cmd>lua require'dap'.step_out()<CR>", { silent = true })
vim.keymap.set("n", "<leader>b", "<Cmd>lua require'dap'.toggle_breakpoint()<CR>", { silent = true })
vim.keymap.set("n", "<leader>B", "<Cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>", { silent = true })
vim.keymap.set("n", "<leader>lp", "<Cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>", { silent = true })
vim.keymap.set("n", "<leader>dr", "<Cmd>lua require'dap'.repl.open()<CR>", { silent = true })
vim.keymap.set("n", "<leader>dl", "<Cmd>lua require'dap'.run_last()<CR>", { silent = true })

-- diagnostics
vim.keymap.set('n', ',e', '<cmd>lua vim.diagnostic.open_float()<CR>', { noremap=true, silent=true })
vim.keymap.set('n', 'ge', '<cmd>lua vim.diagnostic.goto_prev()<CR>', { noremap=true, silent=true })
vim.keymap.set('n', 'gE', '<cmd>lua vim.diagnostic.goto_next()<CR>', { noremap=true, silent=true })
vim.keymap.set('n', ',q', '<cmd>lua vim.diagnostic.setloclist()<CR>', { noremap=true, silent=true })

