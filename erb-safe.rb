# Powered By Saisui @ github.io
# 140 lines robust ERB render
#
# USAGE
#     eval erb <<~ERB
#       Hello!
#       <% for i in 1..10 %>
#       number is <%= i %>
#       <% end %>
#     ERB
#
# __block__ emmit, send yield
#
# ```erb
#   <%*= form do %>
#     <%*= label for: :uid do %>
#       input your <b>UID</b>:
#     <% end %>
#     <%= input :@uid, :@@text %>
#     <%= button :@submit %>
#   <% end %>
# ```
#
# FEATURE
# - code
#     - single code: code must be syntax parsed.
#       `<%.` ... `%>`
#     - block code: normally with another code. `<%` ... `%>`
#     - comment: be ommitted. `<%#` ... `%>`
#     - trim: ommit pre-blanks. `<%-` ... `%>`
# - embed
#   - single embed: eval and embed into output. `<%=` ...`%>`
#   - block embed: print yielding block: 
#     begin `<%*=.*?%>`, end with `<% end\b...%>`
# - custom buf name: `buf` keyword param e.g. `erb(fs, buf: '@_buf')`
#
# @param {String} template - Raw, the pre-compile template text
# @param {Boolean} trim - Toggle ommit pre blanks of code
# @param {String} buf - Buf symbol name, to make scope feature
#
# @return {String} - Ruby code, eval it to get the output text
def erb template, trim = false, buf: '@_buf', buf_i: 0
  ibuf = buf_i == 0 ? buf : buf+buf_i.to_s
  r0 = trim ? /\A(\n?[ \t]*)<%/ : /\A<%/
  re = /\A<%=/
  red= /\A<%\*=/
  rc = /\A<%#/
  rj = /\A(\n?[ \t]*)<%(-)/
  rs = /\A<%\./

  r1  = /\A%>/

  rend = /\A<%( *end.*?)%>/
  ss = template.dup

  ret = ''
  tmp = ''
  rb = false
  embed = false
  is_embed_block = false
  is_single = false
  is_comment = false


  def drop s, n = 1
    return '' if s.empty? || s.nil?
    r = s[0,n]
    s[0..] = s[n..]
    r
  end

  
  catch :block_end do
  until ss.empty?

    if buf_i > 0 and ss =~ rend
      ret << "#{ibuf} << #{tmp.inspect};\n"
      tmp.clear
      drop(ss,$1.size+2)
      ret << "#{ibuf};\n#{$1};\n"
      throw :block_end
    end

    if rb
      if ss =~ r1 &&
         ((embed && !is_embed_block || is_single) ? Ripper.sexp(tmp) : true)

        if is_embed_block
          bufi = buf+(buf_i+1).to_s
          bufii = buf+(buf_i+2).to_s
          ret << "#{bufi} = #{tmp};\n"
          drop(ss, 2)
          tmp.clear
          sub_buf, ss = erb(ss, buf:, buf_i: buf_i+2)
          # pp(buf_i:, sub_buf:, ss:)
          ret << sub_buf
          ret << "#{ibuf} << (#{bufi}).to_s;\n"
          is_embed_block = true
        end

        drop(ss, 1) if ss =~ rj
        drop(ss, 2)
        if embed and tmp and !tmp.empty?
          ret << "#{ibuf} << (#{tmp}).to_s;\n"
        elsif is_comment
        else
          ret << tmp << ";\n"
        end
        rb = embed = is_comment = is_single = is_embed_block = false
        tmp.clear

      else
        tmp << drop(ss,1)
      end
  

    else # static

      unless ss=~ rj || ss =~ r0
        tmp << drop(ss,1)
      else

        drop(ss,$1.size) if $1
        drop(ss,$2.size) if $2

        rb = true

        if tmp != ''
          ret << "#{ibuf} << #{tmp.inspect};\n"
        end

        drop(ss,2)

        if ss[0] == '='
          embed = true
          drop(ss,1)
        end

        if ss[0] == '.'
          is_single = true
          drop(ss,1)
        end

        if ss[0] == '#'
          is_comment = true
          drop(ss,1)
        end

        if ss[0,2] == '*='
          embed = true
          is_embed_block = true 
          drop(ss,2)
        end

        tmp.clear
      # else
      #  tmp << drop(ss,1)
      end

    end

  end

  if rb # || is_comment || is_single || embed
    raise 'SyntaxError: syntax invailed or block not closed'
  end

  unless tmp.empty?
    ret << "#{ibuf} << #{tmp.inspect};\n"
  end
  end

  if buf_i == 0
    "# encoding: utf-8\n#{buf} = '';\n" + ret + buf
  else
    # pp ret: ret, ibuf: ibuf
    ["#{ibuf} = '';\n" + ret, ss]
  end
end

def erbse ss
  require 'erbse'
  Erbse::Engine.new.call(ss).gsub("; ", ";\n")
end
