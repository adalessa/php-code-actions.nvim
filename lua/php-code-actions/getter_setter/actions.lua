local ts_utils = require("nvim-treesitter.ts_utils")
local templates = require("php-code-actions.getter_setter.templates")

require("php-code-actions.getter_setter.queries")

local get_node_text = vim.treesitter.get_node_text

local M = {}

local function tableConcat(t1, t2)
    for i = 1, #t2 do
        t1[#t1 + 1] = t2[i]
    end

    return t1
end

local function getParameters(property_node)
	local property = "var"
	local types = {}
	local nullable = false
    local has_doc_block = false

	local query = vim.treesitter.get_query("php", "Alpha_refactor_property")
	for _, match in query:iter_matches(property_node, 0) do
		for id, subNode in pairs(match) do
			local capture_name = query.captures[id]
			if capture_name == "name" then
				property = string.sub(get_node_text(subNode, 0), 2)
			elseif capture_name == "type" then
				table.insert(types, get_node_text(subNode, 0))
			elseif capture_name == "optional_type" then
				table.insert(types, get_node_text(subNode, 0))
                nullable = true
			end
		end
	end

	local comment_node = ts_utils.get_previous_node(property_node)
	if comment_node ~= nil then
        has_doc_block = true
		local row, column = comment_node:start()
		local test_node = ts_utils.get_root_for_position(row, column)
		local primitive_query = vim.treesitter.get_query("phpdoc", "Alpha_refactor_property_phpdoc_types")
		for _, match in primitive_query:iter_matches(test_node, 0) do
			for _, subNode in pairs(match) do
				local type = get_node_text(subNode, 0)
				if type ~= "null" then
					table.insert(types, type)
				else
					nullable = true
				end
			end
		end
	end

    return property, nullable, types, has_doc_block
end

M.generate_getter_and_setter = function(cursor_node, context)
	return function()
        local property, nullable, types, has_doc_block = getParameters(cursor_node)

        local getter = templates.getGetter(property, nullable, types, has_doc_block)
        local setter = templates.getSetter(property, nullable, types, has_doc_block)

        vim.api.nvim_buf_set_lines(
            0,
            #context.content - 2,
            #context.content - 2,
            false,
            tableConcat(getter, setter)
        )
    end
end

M.generate_getter = function(cursor_node, context)
	return function()
        local property, nullable, types, has_doc_block = getParameters(cursor_node)

        local getter = templates.getGetter(property, nullable, types, has_doc_block)

        vim.api.nvim_buf_set_lines(
            0,
            #context.content - 2,
            #context.content - 2,
            false,
            getter
        )
    end
end

M.generate_setter = function(cursor_node, context)
	return function()
        local property, nullable, types, has_doc_block = getParameters(cursor_node)

        local setter = templates.getSetter(property, nullable, types, has_doc_block)

        vim.api.nvim_buf_set_lines(
            0,
            #context.content - 2,
            #context.content - 2,
            false,
            setter
        )
    end
end

return M
