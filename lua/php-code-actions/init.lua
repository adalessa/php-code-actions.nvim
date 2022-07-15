local null_ls = require("null-ls")
local utils = require("php-code-actions.utils")
local actions = require("php-code-actions.actions")

require("php-code-actions.queries")

local M = {}
M.getter_setter = {
    method = null_ls.methods.CODE_ACTION,
    filetypes = { "php" },
    generator = {
        fn = function (context)
            local cursor_node = utils.get_master_node()
            if cursor_node == nil then
                return
            end
            if cursor_node.type(cursor_node) ~= "property_declaration" then
                return
            end

            return {
                {
                    title = "Generate Setter and Getter",
                    action = actions.generate_getter_and_setter(cursor_node, context),
                },
                {
                    title = "Generate Setter",
                    action = actions.generate_setter(cursor_node, context),
                },
                {
                    title = "Generate Getter",
                    action = actions.generate_getter(cursor_node, context),
                },
            }
        end
    },
}

return M
