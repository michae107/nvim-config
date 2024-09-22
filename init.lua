
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    'rebelot/kanagawa.nvim'
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { 'rebelot/kanagawa.nvim' } },
  -- automatically check for plugin updates
  checker = { enabled = false },
})

vim.o.background = "dark"
vim.cmd('colorscheme kanagawa')

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.opt.number = true
vim.opt.relativenumber = false

-- Create an event handler for the FileType autocommand
vim.api.nvim_create_autocmd('FileType', {
  -- This handler will fire when the buffer's 'filetype' is "cpp" or "c"
  pattern = {'c', 'cpp', 'objc', 'objcpp'},
  callback = function(args)
    -- Define the root markers for your C++ projects
    local root_files = {'compile_commands.json', 'compile_flags.txt', '.git'}
    -- Find the root directory based on the presence of root marker files
    local root_dir = vim.fs.dirname(vim.fs.find(root_files, { 
      path = vim.fs.dirname(args.file), 
      upward = true 
    })[1])

    -- Fallback to the current working directory if no root is found
    if not root_dir then
      root_dir = vim.loop.cwd()
    end

    -- Start the LSP server with the appropriate settings
    vim.lsp.start({
      name = 'clangd',
      cmd = {'clangd', '--background-index'},
      root_dir = root_dir,
    })
  end,
})

vim.api.nvim_set_keymap('n', ',', '<C-f>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '.', '<C-b>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>;', ':', { noremap = true, silent = true })


