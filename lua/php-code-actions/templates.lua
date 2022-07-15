local utils = require("php-code-actions.utils")

local M = {}

local function isNullable(nullable)
    if nullable then
        return "?"
    end

    return ""
end

local function getReturnTypes(nullable, types) if #types > 0 then
        return string.format(": %s%s", isNullable(nullable), table.concat(types, "|"))
    end
    return ""
end

local function getTypeHint(nullable, types) if #types > 0 then
        return string.format("%s%s ", isNullable(nullable), table.concat(types, "|"))
    end
    return ""
end

M.getGetter = function(property, nullable, types, have_dock_block)
    local comment = ""
    if have_dock_block and #types > 0 then
        comment = string.format(
            [[
    /**
     * @return %s
     */
]],
            table.concat(types, "|")
        )
    end

    local fn = string.format(
        [[
    public function get%s()%s
    {
        return $this->%s;
    }]]   ,
        utils.ucfirst(property),
        getReturnTypes(nullable, types),
        property
    )

    return vim.split("\n" .. comment .. fn, "\n")
end

M.getSetter = function(property, nullable, types, have_dock_block)

    local comment = ""
    if have_dock_block and #types > 0 then
        comment = string.format(
            [[
    /**
     * @param %s $%s
     *
     * @return self
     */
]],
            table.concat(types, "|"),
            property
        )
    end
    local fn = string.format(
        [[
    public function set%s(%s$%s): self
    {
        $this->%s = $%s;

        return $this;
    }]]   ,
        utils.ucfirst(property),
        getTypeHint(nullable, types),
        property,
        property,
        property
    )

    return vim.split("\n" .. comment .. fn, "\n")
end

return M
