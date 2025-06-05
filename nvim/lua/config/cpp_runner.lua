local cpp_runner_term_bufnr = nil
local cpp_runner_term_winid = nil

vim.api.nvim_create_autocmd("FileType", {
    pattern = "cpp",
    callback = function()
        vim.keymap.set("n", "<F5>", function()
            local file = vim.fn.expand("%:p")
            local outfile = "/tmp/" .. vim.fn.expand("%:t:r")

            vim.cmd("w")

            -- Close previous floating window
            if cpp_runner_term_winid and vim.api.nvim_win_is_valid(cpp_runner_term_winid) then
                vim.api.nvim_win_close(cpp_runner_term_winid, true)
            end

            -- Open floating terminal
            local width = math.floor(vim.o.columns * 0.8)
            local height = math.floor(vim.o.lines * 0.4)
            local row = math.floor((vim.o.lines - height) / 2)
            local col = math.floor((vim.o.columns - width) / 2)

            cpp_runner_term_bufnr = vim.api.nvim_create_buf(false, true)
            cpp_runner_term_winid = vim.api.nvim_open_win(cpp_runner_term_bufnr, true, {
                relative = "editor",
                width = width,
                height = height,
                row = row,
                col = col,
                style = "minimal",
                border = "rounded",
            })

            vim.fn.termopen(string.format("g++ '%s' -o '%s' && '%s'", file, outfile, outfile))
            vim.cmd("startinsert")
        end, { buffer = true, desc = "Run C++ in floating terminal" })
    end,
})
