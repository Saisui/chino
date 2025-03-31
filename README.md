# CHINO - the better ERB / EJS

<img src="https://media3.giphy.com/media/qTeLrzpDZBY2c/giphy.gif"/>

Just Cappuccino! 🍉

The 16 lines ERB/EJS fastest render engine.

## Have a LOOK

```jinja
{# file: hello.chino #}
{% @mahou.each do |shoujo| %}
Hello, {{shoujo}}!
{% end %}
It's {{Time.now}}
```

```ruby
# file: world.rb
@mahou = %w[madoka homura sayaka kyoko mami]
eval chino(File.read('hello.chino'), true)
```

## features

- 4 things
  - __static__
  - __single-block__
  - __box-block__
  - __embed__

- more function:
  - __comment__
  - __code__
  - __embed__

- custom buf variable, binding free.

- custom terminators

- easy escape

- fastest

# USAGE
You can use like...
```ruby
require './erb'
eval erb <<~ERB, true
  <span class="dirpath">
    <% for path in "/home/app/public/asset/music".split('/').pyramid %>
    /<a href="<%= path.join('/')%>"><%= path.last %></a>
    <% end %>
  </span>
ERB
```

## escape Terminator used string

if `block: %w[{% %}], embed: %w[{{ }}], comment: %w[{# #}}]`

you use

```jinja
code term: {{"\{\%"}} code {{"\%\}"}}
embed term: {{"\{\{"}} value {{"\}\}"}}
comment term: {{"\{\#"}} comment {{"\#\}"}}
```

you can preduce text `{%` into `{{"\{\%"}}`

| term  | str | escaped |
| - | - | - |
| block | `{%` | `{{"\{\%"}}` |
| | `%}` | `{{"\%\}}}` |
| embed | `{{` | `{{"\{\{"}}` |
|  | `}}` | `{{"\}\}"}}` |
| comment | `{#` | `{{"\{\#"}}` |
| | `#}` | `{{"\#\}"}}` |

### Hash/Block in Embed `{{...}}`

For shorter raw code.

Pattern is a lazy match regular expression.

Please use blanks to break terminator-string.

__DO__

```jinja
{{ { madoka: 'homura' } }
```

_do not_

```jinja
{{{ madoka:'homura' }}}
```

__DO__

```jinja
{{ take { { madoka: 'homura' } } }}
```

_do not_

```jinja
{{take{{madoka:'homura'}}}}
```

## Use CHINO

You can use `chino` for more features
1. custom `buf` variabld
2. custom terminators like `{%` block `%}`, `{{` embed `}}`
  `{#` comment `#}`.

### example

file:

```jinja
{# file 1.chino #}
{% for i in 1..5 %}
number: {{i}}
{% end %}
you can use `value is {{"\{\{ value \}\}"}}` to terminators bracket!
like `{{"\{\{\"\\\{\\\{ value \\\}\\\}\"\}\}"}}`
finish
```
compile:

```ruby

eval chino(File.read('1.chino'), true,
  buf: '_buf',
  block: %w[{% %}],
  embed: %w[{{ }}],
  comment: %w[{# #}]
)
```

will output:

```markdown
number: 1
number: 2
number: 3
number: 4
number: 5
you can use `value is {{ value }}` to embed terminators!
like `{{"\{\{ value \}\}"}}`
finish
```

## use Method & Callable
set the buf symbol is not a `local variable`.
could be follows:
1. instance_variable `@_instance_buf`
2. class_variable `@@_class_buf`
3. global_variable `$_global_buf`
4. __EJS__ use option `{ global: false, local: true, here: this}`

when you call a callable, if it is in a __box block__,
it must be in a pair of __BLOCK__ terminator.

such as `let's {% hello("MADOKA") %}`

it does...

```ruby
chino(File.read('2.chino'), true, buf: '@_buf')
```

when define...

in __single block__: `{% def ... end %}`

use `{{ fun() }}`

```jinja
  {# in single block #}
  {%
    def hello(name)
      "HELLO, #{name}!"
    end
  %}

  {# use embed #}
  {{ hello "MADOKA" }}
  Best Wishes
```

in __box block__ `{% def %} ... {% end %}`

USE `{% fun() %}`

```jinja
  {# in box block #}

  {% def hello(name) %}
  HELLO, {{name}}!
  {% end %}

  {# use single block #}
  {% hello "MADOKA" %}

  Best Wishes
```

DO NOT

```jinja
  {# box-block with embed #}
  {# it does not expected result #}

  {% def hello(name) %}
  HELLO, {{name}}!
  {% end %}

  {# embed cause unexpected result #}
  {{ hello "MADOKA" }}

  Best Wishes
```

because it cause __2 times__ of `buf` push.
