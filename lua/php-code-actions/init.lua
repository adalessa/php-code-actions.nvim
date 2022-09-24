local null_ls = require("null-ls")
local utils = require("php-code-actions.utils")
local getter_setter_actions = require("php-code-actions.getter_setter.actions")
local file_creator_actions = require("php-code-actions.file_creator.actions")

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
                    action = getter_setter_actions.generate_getter_and_setter(cursor_node, context),
                },
                {
                    title = "Generate Setter",
                    action = getter_setter_actions.generate_setter(cursor_node, context),
                },
                {
                    title = "Generate Getter",
                    action = getter_setter_actions.generate_getter(cursor_node, context),
                },
            }
        end
    },
}

M.file_creator = {
    method = null_ls.methods.CODE_ACTION,
    filetypes = { "php" },
    generator = {
        fn = function ()
            return file_creator_actions
        end
    }
}

return M
