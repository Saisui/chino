# erb
16 lines erb render engine

## USAGE
You can use like...
```ruby
require './erb'
eval erb <<~ERB, true
<span class="dirpath">
<% for path in "/home/app/public/asset/music".split('/').pyramid%>
/<a href="<%= path.join('/')%>"><%= path.last %></a>
<% end %>
</span>
ERB
```

## Use ERB2

You can use `erb2` for more features
1. custom `buf` variabld
2. custom terminators like `{%` block `%}`, `{{` embed `}}`
  `{#` comment `#}`.

### example

file:

```jinja
{# file 1.jinja #}
{% for i in 1..5 %}
number: {{i}}
{% end %}
you can use `value is {{"\{\{ value \}\}"}}` to terminators bracket!
like `{{"\{\{\"\\\{\\\{ value \\\}\\\}\"\}\}"}}`
finish
```
compile:

```ruby

eval erb2(File.read('1.jinja'), true,
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

### advanced usage

#### use defined method
set the buf symbol is not a `local variable`.
could be follows:
1. instance_variable `@_instance_buf`
2. class_variable `@@_class_buf`
3. global_variable `$_global_buf`

when you call a callable, if it is in a __box block__,
it must be in a pair of __BLOCK__ terminator.

such as `let's {% hello("MADOKA") %}`

it does...

```ruby
erb2(File.read('2.jinja'), true, buf: '@_buf')
```

when define...

in __single block__, you use `{{ fun() }}`

jinja
```
  {# in single block #}
  {%
    def hello(name)
      "HELLO, #{name}!"
    end
  %}
  it's {{Time.now}}
  {{hello "MADOKA"}}
  Best Wishes
JINJA
```

in __box block__

you use `{% fun() %}`

``ruby
erb2(<<~JINJA, true, buf: '@_buf')
  {% def hello(name) %}
   HELLO, {{name}}!
  {% end %}
  it's {{Time.now}}
  {% hello "MADOKA" %}
  Best Wishes
JINJA
```

do not

```ruby
erb2(<<~JINJA, true, buf: '@_buf')
  {% def hello(name)
  HELLO, {{name}}!
  {% end %}
  it's {{Time.now}}
  {{hello "MADOKA"}}
  Best Wishes
JINJA
```

because it cause 2 times `buf` push.
