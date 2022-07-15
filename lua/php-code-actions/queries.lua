vim.treesitter.set_query(
    "php",
    "Alpha_refactor_property",
    [[
   [
        (union_type
            (primitive_type) @type
        )
        (union_type
            (optional_type
                (primitive_type) @optional_type
            )
        )
        (union_type
            (named_type) @type
        )
        (union_type
            (optional_type
                (named_type) @optional_type
            )
        )
        (property_element
            (variable_name) @name
        )
   ]
]]
)

vim.treesitter.set_query(
    "phpdoc",
    "Alpha_refactor_property_phpdoc_types",
    [[
    [
        (type_list
            (primitive_type) @primitive
        )
        (type_list
            (named_type
                (name) @class
            )
        )
    ]
    ]]
)
