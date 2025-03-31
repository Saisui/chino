# CHINO - the Better EJS

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

## USAGE

see [README.md](ruby README) also
