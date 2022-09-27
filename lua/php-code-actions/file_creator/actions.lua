local templates = require("php-code-actions.file_creator.templates")
local composer = require("composer")

local function create_buffer(class, folder)
    vim.cmd(string.format("edit %s%s.php", folder, class))

    return vim.api.nvim_get_current_buf()
end

local function get_content(template, name, namespace)
    local class = string.format(template, namespace, name)

    return vim.split(class, "\n")
end

local function ensure_final_slash(namespace)
    if string.sub(namespace, -1) ~= "\\" then
        namespace = namespace .. "\\"
    end

    return namespace
end

local function remove_final_slash(value)
    if string.sub(value, -1) == "\\" then
        value = string.sub(value, 1, string.len(value) - 1)
    end

    return value
end

local function get_directory(namespace)
    namespace = ensure_final_slash(namespace)
    local autoloads = composer.query({ "autoload", "psr-4" })
    local directory = ""
    for key, value in pairs(autoloads) do
        if string.find(namespace, key) then
            directory = string.gsub(namespace, key, value)
        end
    end

    return string.gsub(directory, "\\", "/")
end

local function set_buffer_content(buffer, content)
    vim.api.nvim_buf_set_lines(buffer, 0, -1, false, content)
    vim.api.nvim_win_set_cursor(0, { #content - 1, 0 })
end

local function create(template_name, name, namespace)
    local template = templates[template_name]
    local directory = get_directory(namespace)
    vim.fn.mkdir(directory, "p")
    local buffer = create_buffer(name, directory)
    local content = get_content(template, name, remove_final_slash(namespace))
    set_buffer_content(buffer, content)
    vim.cmd("write")

    return buffer
end

local actions = {}

-- for name, _ in pairs(templates) do
--     table.insert(actions, {
--         title = string.format("Create %s", name),
--         action = function()
--             vim.ui.input({ prompt = "Name: " }, function(file_name)
--                 if file_name == nil then
--                     return
--                 end

--                 vim.ui.input({
--                     prompt = "Namespace: ",
--                     default = composer.namespace(),
--                 }, function(namespace)
--                     if namespace == nil then
--                         return
--                     end

--                     return create(name, file_name, namespace)
--                 end)
--             end)
--         end,
--     })
-- end

actions.create = function (name)
    return function ()
        vim.ui.input({ prompt = "Name: " }, function(file_name)
            if file_name == nil then
                return
            end

            vim.ui.input({
                prompt = "Namespace: ",
                default = composer.namespace(),
            }, function(namespace)
                    if namespace == nil then
                        return
                    end

                    return create(name, file_name, namespace)
                end)
        end)
    end
end

return actions
