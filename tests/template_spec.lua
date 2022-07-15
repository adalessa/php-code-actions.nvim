describe("Test templates for getter and setter", function ()
    it("Test getter", function ()
        local templates = require("php-code-actions.templates")
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
        local templates = require("php-code-actions.templates")
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
end)
