return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            local configs = require("nvim-treesitter.configs")
            configs.setup({
                -- enable syntax highlighting
                highlight = {
                    enable = true,
                    -- Keep additional highlighting for better template literal support
                    additional_vim_regex_highlighting = { "javascript", "typescript" },
                },
                -- enable indentation
                indent = {
                    enable = true,
                },
                -- enable autotagging (w/ nvim-ts-autotag plugin)
                autotag = {
                    enable = true,
                    enable_rename = true,
                    enable_close = true,
                    enable_close_on_slash = true,
                    filetypes = { "html", "xml", "javascript", "javascriptreact", "typescript", "typescriptreact" },
                },
                fold = {
                    enable = true,
                },
                -- ensure these language parsers are installed
                ensure_installed = {
                    "json",
                    "javascript",
                    "query",
                    "typescript",
                    "tsx",
                    "php",
                    "yaml",
                    "html",
                    "css",
                    "markdown",
                    "markdown_inline",
                    "bash",
                    "lua",
                    "vim",
                    "vimdoc",
                    "c",
                    "dockerfile",
                    "gitignore",
                    "astro",
                },
                -- auto install above language parsers
                auto_install = false,
            })

            -- Set up folding options
            vim.opt.foldmethod = "expr"
            vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
            vim.opt.foldlevel = 99 -- Start with all folds open
            vim.opt.foldenable = true
        end
    }
}
