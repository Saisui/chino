# CHINO - the Better EJS

<img src="https://media3.giphy.com/media/qTeLrzpDZBY2c/giphy.gif"/>

Just Cappuccino! ☕

30 lines most tiny template lib!

## Have a LOOK

file:

```erb
<% for(let name of ['MADOKA', 'HOMURA', 'SAYAKA', 'KYOKO', 'MAMI', 'IROHA']) { %>
Hello, {{name}}!
<% } %>

It's {{new Date()}}!
```
render

```js
const { readFileSync } = await import("fs");

const { chino } = await import('./chino.js');

let template = readFileSync('hello.chino', 'utf-8');

let opt = { trim: true, block: ['<%','%>']};

let output = eval(chino(template, opt));

document.body.innerHTML = output;
```

output

```text
Hello, MADOKA!
Hello, HOMURA!
Hello, SAYAKA!
Hello, KYOKO!
Hello, MAMI!
Hello, IROHA!
It's Mon Apr 1 2025 00:00:00 GST (Greenwich Standard Time)!
```

# CHINO vs. Vanilla Template String

USE __CHINO__ 🍵

```erb
Chino's Meal
<% (['coffee', 'cola', 'cha']).forEach((drink, i) => { %>
Day {{ i+1 }}, Chino Drink {{drink}}!
<% }) %>
Best Wishes!
```

WITHOUT __CHINO__ 🍼

_nest hill_

```js
`Chino's Meal
${[[1, 'coffee'], [2, 'cola'], [3, 'cha']].map( ([i, drink]) => {
    return `Day ${i}, Chino Drink ${drink}!\n`
  }).join("")
}Best Wishes!`
```

# USAGE

## Trim Mode

ommit code-whole line, default false.

```js
let template = "what number?\n<% let a = 3 %>\nnumber is {{ a }}"
chino(template, { trim: true })
```

will be

```text
what number?
number is 3
```

## USE function

### Block Code

```erb
<% function hello(name) { %>
Hello, {{name}}!
<% } %>

<% hello('MADOKA') %>
```
### Single Code

```erb
<% let hello = name => `hello, ${name}!` %>
{{hello('homura')}}
```

## custom terminators

custom terminator to aspect source text.

```js
chino(fs, {
  block: ['<%','%>'],
  embed: ['{{','}}'],,
  comment: ['{#','#}'],
})
```

list of custom examples

- __block__: `<%`, `%>`; `{%`, `%}`; `[%`, `%]`; `(%`, `%)` ...etc
- __embed__: `<%=`, `%>`; `{{`, `}}`; `{=`, `=}` ... etc
- __comment__: `<%#`, `%>`; `<#`, `#>`; `(#`, `#)` ... etc

__TIPS__: terminator should be at least 2 characters,

and not frequency string.

## escape
you can preduce text `<%` into `{{"\<\%"}}`

| term  | str | escaped |
| - | - | - |
| code | `<%` | `{{"\<\%"}}` |
| | `%>` | `{{"\%\>}}` |
| embed | `{{` | `{{"\{\{"}}` |
|  | `}}` | `{{"\}\}"}}` |
| comment | `<#` | `{{"\<\#"}}` |
| | `#}` | `{{"\#\>"}}` |

### Object/Scope in Embed `{{...}}`

For shorter raw code.

Pattern is a lazy match regular expression.

Please use blanks to break terminator-string.

#### __DO__

```jinja
{{ { madoka: 'homura' } }
```

_do not_

```jinja
{{{ madoka:'homura' }}}
```

#### __DO__

```jinja
{{ function() { return { madoka: 'homura' } } }}
```

_do not_

```jinja
{{function(){ return {madoka:'homura'}}}}
```
### more usage

see <a href="README.md">ruby README</a> also
