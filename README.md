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
