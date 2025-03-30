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
2. custom seperators like `{%` block `%}`, `{{` embed `}}`
  `{#` comment `#}`.

### example

file:

```jinja
{# file 1.jinja #}
{% for i in 1..5 %}
number: {{i}}
{% end %}
you can use `value is {{"\{\{ value \}\}"}}` to embed bracket!
like `{{"\{\{\"\\\{\\\{ value \\\}\\\}\"\}\}"}}`
finish
```
compile:

```ruby

erb2(File.read('1.jinja'), true,
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
you can use `value is {{ value }}` to embed bracket!
like `{{"\{\{ value \}\}"}}`
finish
```

