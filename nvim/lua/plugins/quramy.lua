-- Add this as a new plugin file or add to your existing plugin list
return {
    -- Template string highlighting for HTML-in-JS
    {
        'Quramy/vim-js-pretty-template',
        ft = { 'javascript', 'typescript', 'javascriptreact', 'typescriptreact' },
        config = function()
            -- Enable template string detection
            vim.g.js_pretty_template_tags = { 'html', 'htm', 'jsx' }
        end
    },

    -- Alternative: nvim-ts-context-commentstring for better commenting
    {
        'JoosepAlviste/nvim-ts-context-commentstring',
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
        config = function()
            require('ts_context_commentstring').setup({
                enable_autocmd = false,
                languages = {
                    javascript = {
                        __default = '// %s',
                        jsx_element = '{/* %s */}',
                        jsx_fragment = '{/* %s */}',
                        jsx_attribute = '// %s',
                        comment = '// %s',
                        template_string = '<!-- %s -->'
                    }
                }
            })
        end
    }
}
