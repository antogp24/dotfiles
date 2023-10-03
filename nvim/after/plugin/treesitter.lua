-- Fix the lua.so not valid Win32 application
require ('nvim-treesitter.install').compilers = { 'clang' }

require'nvim-treesitter.configs'.setup {
  ensure_installed = { "c", "odin", "vim", "vimdoc"},
  sync_install = false,
  auto_install = true,

  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
}
