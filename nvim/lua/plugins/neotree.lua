return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
    },
    lazy = false,
    opts = {
        close_if_last_window = false,
        enable_git_status = true,

        window = {
            position = "left",
            width = 30,
        },

        filesystem = {
            follow_current_file = {
                enabled = true,
            },
        },
    },

    config = function(_, opts)
        require("neo-tree").setup(opts)

        -- Key mapping
        vim.keymap.set('n', '<leader>b', ':Neotree toggle<CR>', { desc = 'Toggle Neo-tree' })
    end
}
