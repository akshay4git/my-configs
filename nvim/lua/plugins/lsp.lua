return {
    'neovim/nvim-lspconfig',
    dependencies = {
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',
        -- Autocompletion
        'hrsh7th/nvim-cmp',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
        'saadparwaiz1/cmp_luasnip',
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-nvim-lua',
        -- Snippets
        'L3MON4D3/LuaSnip',
        'rafamadriz/friendly-snippets',
    },
    config = function()
        local autoformat_filetypes = { "lua" }

        vim.api.nvim_create_autocmd('LspAttach', {
            callback = function(args)
                local client = vim.lsp.get_client_by_id(args.data.client_id)
                local bufnr = args.buf
                if not client then return end

                -- Autoformat on save
                if vim.tbl_contains(autoformat_filetypes, vim.bo[bufnr].filetype) then
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        buffer = bufnr,
                        callback = function()
                            vim.lsp.buf.format({
                                formatting_options = { tabSize = 4, insertSpaces = true },
                                bufnr = bufnr,
                                id = client.id
                            })
                        end
                    })
                end

                -- Keymaps
                local map = vim.keymap.set
                local opts = { buffer = bufnr }
                map('n', 'K', vim.lsp.buf.hover, opts)
                map('n', 'gd', vim.lsp.buf.definition, opts)
                map('n', 'gD', vim.lsp.buf.declaration, opts)
                map('n', 'gi', vim.lsp.buf.implementation, opts)
                map('n', 'go', vim.lsp.buf.type_definition, opts)
                map('n', 'gr', vim.lsp.buf.references, opts)
                map('n', 'gs', vim.lsp.buf.signature_help, opts)
                map('n', 'gl', vim.diagnostic.open_float, opts)
                map('n', '<F2>', vim.lsp.buf.rename, opts)
                map({ 'n', 'x' }, '<F3>', function() vim.lsp.buf.format({ async = true }) end, opts)
                map('n', '<F4>', vim.lsp.buf.code_action, opts)
            end
        })

        -- Diagnostic UI
        vim.diagnostic.config({
            virtual_text = true,
            severity_sort = true,
            float = {
                style = 'minimal',
                border = 'rounded',
                header = '',
                prefix = '',
            },
            signs = {
                text = {
                    [vim.diagnostic.severity.ERROR] = '✘',
                    [vim.diagnostic.severity.WARN] = '▲',
                    [vim.diagnostic.severity.HINT] = '⚑',
                    [vim.diagnostic.severity.INFO] = '»',
                },
            },
        })

        -- LSP handler borders
        vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
            vim.lsp.handlers.hover,
            { border = 'rounded' }
        )
        vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
            vim.lsp.handlers.signature_help,
            { border = 'rounded' }
        )

        -- CMP setup
        local cmp = require('cmp')
        require('luasnip.loaders.from_vscode').lazy_load()
        vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }

        cmp.setup({
            preselect = 'item',
            completion = { completeopt = 'menu,menuone,noinsert' },
            window = { documentation = cmp.config.window.bordered() },
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body)
                end,
            },
            formatting = {
                fields = { 'abbr', 'menu', 'kind' },
                format = function(entry, item)
                    local source = entry.source.name
                    item.menu = string.format('[%s]', source == 'nvim_lsp' and 'LSP' or source)
                    return item
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ['<CR>'] = cmp.mapping.confirm({ select = false }),
                ['<C-f>'] = cmp.mapping.scroll_docs(5),
                ['<C-u>'] = cmp.mapping.scroll_docs(-5),
                ['<C-e>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then cmp.abort() else cmp.complete() end
                end),
                ['<Tab>'] = cmp.mapping(function(fallback)
                    local col = vim.fn.col('.') - 1
                    if cmp.visible() then
                        cmp.select_next_item({ behavior = 'select' })
                    elseif col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
                        fallback()
                    else
                        cmp.complete()
                    end
                end, { 'i', 's' }),
                ['<S-Tab>'] = cmp.mapping.select_prev_item({ behavior = 'select' }),
                ['<C-d>'] = cmp.mapping(function(fallback)
                    local ls = require('luasnip')
                    if ls.jumpable(1) then ls.jump(1) else fallback() end
                end, { 'i', 's' }),
                ['<C-b>'] = cmp.mapping(function(fallback)
                    local ls = require('luasnip')
                    if ls.jumpable(-1) then ls.jump(-1) else fallback() end
                end, { 'i', 's' }),
            }),
            sources = {
                { name = 'path' },
                { name = 'nvim_lsp' },
                { name = 'buffer',  keyword_length = 3 },
                { name = 'luasnip', keyword_length = 2 },
            },
        })

        -- LSP config
        local capabilities = require('cmp_nvim_lsp').default_capabilities()

        require('mason').setup()
        require('mason-lspconfig').setup({
            ensure_installed = {
                -- Web (FIXED: Added missing TypeScript server)
                "ts_ls", -- Correct name for TypeScript Language Server
                "html",
                "cssls",
                "jsonls",
                "eslint",
                "emmet_ls",
                "tailwindcss",
                -- C++
                "clangd",
                -- Lua
                "lua_ls",
            },
            handlers = {
                function(server_name)
                    require('lspconfig')[server_name].setup({
                        capabilities = capabilities,
                    })
                end,
                lua_ls = function()
                    require('lspconfig').lua_ls.setup({
                        capabilities = capabilities,
                        settings = {
                            Lua = {
                                runtime = { version = 'LuaJIT' },
                                diagnostics = { globals = { 'vim' } },
                                workspace = {
                                    library = vim.api.nvim_get_runtime_file("", true),
                                    checkThirdParty = false,
                                },
                            },
                        },
                    })
                end,
                -- IMPROVED: Better TypeScript/JavaScript config for template literals
                ts_ls = function()
                    require('lspconfig').ts_ls.setup({
                        capabilities = capabilities,
                        -- Enable better support for template literals
                        filetypes = {
                            "javascript",
                            "javascriptreact",
                            "javascript.jsx",
                            "typescript",
                            "typescriptreact",
                            "typescript.tsx"
                        },
                        settings = {
                            typescript = {
                                preferences = {
                                    includePackageJsonAutoImports = "on",
                                },
                            },
                            javascript = {
                                preferences = {
                                    includePackageJsonAutoImports = "on",
                                },
                            },
                        },
                        on_attach = function(client)
                            client.server_capabilities.documentFormattingProvider = false
                        end,
                    })
                end,
                -- IMPROVED: HTML LSP to work with JS files too
                html = function()
                    require('lspconfig').html.setup({
                        capabilities = capabilities,
                        -- Allow HTML LSP to work in JS files for template literals
                        filetypes = { "html", "templ", "javascript", "javascriptreact", "typescript", "typescriptreact" },
                        settings = {
                            html = {
                                format = {
                                    templating = true,
                                    wrapLineLength = 120,
                                    wrapAttributes = 'auto',
                                },
                                hover = {
                                    documentation = true,
                                    references = true,
                                },
                            },
                        },
                    })
                end,
                -- IMPROVED: Emmet for template literals
                emmet_ls = function()
                    require('lspconfig').emmet_ls.setup({
                        capabilities = capabilities,
                        filetypes = {
                            "html",
                            "css",
                            "scss",
                            "javascript",
                            "javascriptreact",
                            "typescript",
                            "typescriptreact"
                        },
                        init_options = {
                            html = {
                                options = {
                                    -- Enable Emmet inside template literals
                                    ["bem.enabled"] = true,
                                },
                            },
                        },
                    })
                end,
                clangd = function()
                    require('lspconfig').clangd.setup({
                        capabilities = capabilities,
                        cmd = { "clangd", "--background-index", "--clang-tidy" },
                    })
                end,
                -- FIXED: Moved cssls config inside handlers
                cssls = function()
                    require('lspconfig').cssls.setup({
                        capabilities = capabilities,
                        filetypes = { "css", "scss", "less" }, -- DO NOT include wofi-style files
                        on_attach = function(client, bufnr)
                            local filename = vim.api.nvim_buf_get_name(bufnr)
                            if filename:match("wofi/style%.css") then
                                client.stop() -- Disable LSP for Wofi styles
                            end
                        end,
                    })
                end,
            },
        })
    end
}
