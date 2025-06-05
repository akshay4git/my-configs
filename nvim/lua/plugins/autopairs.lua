return {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
        local autopairs = require("config.autopairs") -- load module
        vim.keymap.set('n', '<leader>nn', autopairs.toggle, { desc = 'Toggle autopairs' })
    end,
}
