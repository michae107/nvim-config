vim.o.background = "dark"

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

