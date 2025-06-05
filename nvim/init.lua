require('config.options')
require('config.keybinds')
require('config.lazy')
require('config.cpp_runner')
require("plugins.autopairs")


vim.api.nvim_create_autocmd("FileType", {
    pattern = { "html", "xml" },
    callback = function()
        vim.opt_local.foldmethod = "syntax"
    end,
})
