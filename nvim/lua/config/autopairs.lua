local M = {}

local npairs = require("nvim-autopairs")

local enabled = true

function M.toggle()
    enabled = not enabled
    if enabled then
        npairs.enable()
        vim.notify("AutoPairs enabled")
    else
        npairs.disable()
        vim.notify("AutoPairs disabled")
    end
end

return M
