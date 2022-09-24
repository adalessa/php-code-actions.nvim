local templates = {}

templates.class = [[
<?php

declare(strict_types=1);

namespace %s;

class %s
{
}]]

templates.interface = [[
<?php

declare(strict_types=1);

namespace %s;

interface %s
{
}]]

templates.enum = [[
<?php

declare(strict_types=1);

namespace %s;

enum %s
{
}]]

templates.trait = [[
<?php

declare(strict_types=1);

namespace %s;

trait %s
{
}]]

return templates
