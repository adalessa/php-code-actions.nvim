describe("Test templates for getter and setter", function ()
    it("Test getter", function ()
        local templates = require("php-code-actions.getter_setter.templates")
        assert.are.same(
            {
                "",
                "    public function getVar(): int",
                "    {",
                "        return $this->var;",
                "    }"
            },
            templates.getGetter("var", false, {"int"}, false))
    end)

    it("Test Setter", function ()
        local templates = require("php-code-actions.getter_setter.templates")
        assert.are.same(
            {
                "",
                "    public function setVar(int $var): self",
                "    {",
                "        $this->var = $var;",
                "",
                "        return $this;",
                "    }"
            },
            templates.getSetter("var", false, {"int"}, false))
    end)

    it("Generate Setter with nullable field and comments", function ()
        local templates = require("php-code-actions.getter_setter.templates")
        assert.are.same(
            {
                "",
                "    /**",
                "     * @param int|null $var",
                "     *",
                "     * @return $this",
                "     */",
                "    public function setVar(?int $var): self",
                "    {",
                "        $this->var = $var;",
                "",
                "        return $this;",
                "    }"
            },
            templates.getSetter("var", true, {"int"}, true))
    end)

    it("Generate Getter with nullable field and comments", function ()
        local templates = require("php-code-actions.getter_setter.templates")
        assert.are.same(
            {
                "",
                "    /**",
                "     * @return int|null",
                "     */",
                "    public function getVar(): ?int",
                "    {",
                "        return $this->var;",
                "    }"
            },
            templates.getGetter("var", true, {"int"}, true))
    end)
end)
