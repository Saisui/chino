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
<% for(let i, drink in ['coffee', 'cola', 'cha']) { %>
Day {{ i+1 }}, Chino Drink {{drink}}!
<% } %>
```

WITHOUT __CHINO__ 🍼

_nest hill_

```js
`Chino's Meal
${[[1, 'coffee'], [2, 'cola'], [3, 'cha']].map( ([i, drink]) => {
    return `Day ${i}, Chino Drink ${drink}!\n`
  }).join("")
}`
```

# USAGE

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

## escape

# USAGE

see <a href="README.md">ruby README</a> also
