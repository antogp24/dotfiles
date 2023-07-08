local function file_exists(name)
   local f = io.open(name,"r")
   local exists = (f ~= nil)
   if exists then
       io.close(f)
   end
   return exists
end

function C_project_build()
    if file_exists("build.sh") then
        vim.cmd(":Dispatch bear -- ./build.sh")
    else
        vim.cmd(":Make")
    end
end

function C_project_run()
    if file_exists("run.sh") then
        vim.cmd(":Dispatch ./run.sh")
    else
        vim.cmd(":Make run")
    end
end

vim.api.nvim_create_autocmd("FileType c", { command = [[nnoremap <M-m> :lua C_project_build()<CR>]] })
vim.api.nvim_create_autocmd("FileType c", { command = [[nnoremap <M-.> :lua C_project_run()<CR>]] })

-- cpp
vim.api.nvim_create_autocmd({"BufEnter", "BufNew *.cpp"}, { command = [[nnoremap <silent> ;p :e %<.hpp<CR>]] })
vim.api.nvim_create_autocmd({"BufEnter", "BufNew *.hpp"}, { command = [[nnoremap <silent> ;p :e %<.cpp<CR>]] })

vim.api.nvim_create_autocmd({"BufEnter", "BufNew *.cpp"}, { command = [[nnoremap <silent> ;vp :leftabove vs %<.hpp<CR>]] })
vim.api.nvim_create_autocmd({"BufEnter", "BufNew *.hpp"}, { command = [[nnoremap <silent> ;vp :rightbelow vs %<.cpp<CR>]] })

vim.api.nvim_create_autocmd({"BufEnter", "BufNew *.cpp"}, { command = [[nnoremap <silent> ;xp :leftabove split %<.hpp<CR>]] })
vim.api.nvim_create_autocmd({"BufEnter", "BufNew *.hpp"}, { command = [[nnoremap <silent> ;xp :rightbelow split %<.cpp<CR>]] })

-- c

vim.api.nvim_create_autocmd({"BufEnter", "BufNew *.c"}, { command = [[nnoremap <silent> ;p :e %<.h<CR>]] })
vim.api.nvim_create_autocmd({"BufEnter", "BufNew *.h"}, { command = [[nnoremap <silent> ;p :e %<.c<CR>]] })

vim.api.nvim_create_autocmd({"BufEnter", "BufNew *.c"}, { command = [[nnoremap <silent> ;vp :leftabove vs %<.h<CR>]] })
vim.api.nvim_create_autocmd({"BufEnter", "BufNew *.h"}, { command = [[nnoremap <silent> ;vp :rightbelow vs %<.c<CR>]] })

vim.api.nvim_create_autocmd({"BufEnter", "BufNew *.c"}, { command = [[nnoremap <silent> ;xp :leftabove split %<.h<CR>]] })
vim.api.nvim_create_autocmd({"BufEnter", "BufNew *.h"}, { command = [[nnoremap <silent> ;xp :rightbelow split %<.c<CR>]] })

