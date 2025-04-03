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
#       `<%. ... %>`
#     - block code: normally with another code. `<% ... %>`
#     - comment: be ommitted. `<%# ... %>`
#     - trim: ommit pre-blanks. `<%- ... %>`7
#     - one line code: <%# a_line: on %>
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
def erb template, trim = false, buf: '_buf', buf_i: 0
  ibuf = buf_i == 0 ? buf : buf+buf_i.to_s
  r0 = trim ? /\A(\n?[ \t]*)<%/ : /\A<%/
  re = /\A<%=/
  red= /\A<%\*=/
  rc = /\A<%#/
  rj = /\A(\n?[ \t]*)<%(-)/
  rs = /\A<%\./
  ra = /^\s*%[^%]/

  r1  = /\A%>/
  # r1_do = /\Ado\s*%>/m

  # rend = /\A<%( *end\b.*?)%>/m
  rend = /\A<%(-?)( *(?:end\b|\}).*?)%>/m
  ss = template.dup

  ret = ''
  tmp = ''
  rb = false
  embed = false
  is_block = false
  is_single = false
  is_comment = false
  is_a_line = false
  is_cut_blanks = false

  def drop s, n = 1
    return '' if s.empty? || s.nil?
    r = s[0,n]
    s[0..] = s[n..]
    r
  end

  def parsed(ss)
    Ripper.sexp Ripper.lex(ss).map { |_,k,s,_|
      ([k, s] in [:on_kw, 'yield']) ? s + '_call' : s
    }.join
  end
  
  catch :block_end do
    until ss.empty?

      if buf_i > 0 and ss =~ rend
        ret << "#{ibuf} << #{tmp.inspect};\n"
        tmp.clear
        drop(ss,$1.size+$2.size + 2)
        ret << "#{ibuf};\n#{$2};\n"
        throw :block_end
      end

      if rb
        # if ss =~ r1_do
        #  is_block = true
        # end

        if ss =~ r1 &&
           ((embed && !is_block || is_single) ? parsed(tmp) : true)

          if is_block
            bufi = buf+(buf_i+1).to_s
            bufii = buf+(buf_i+2).to_s

            if embed
              ret << "#{bufi} = "
            end

            ret << "#{tmp};\n"

            drop(ss, 2)
            tmp.clear
            sub_buf, ss = erb(ss, buf:, buf_i: buf_i+2)
            ret << sub_buf

            if embed
              ret << "#{ibuf} << #{bufi}.to_s;\n"
            end

            is_block = true
          end

          drop(ss, 1) if ss =~ rj
          drop(ss, 2)
          if embed and tmp and !tmp.empty?
            ret << "#{ibuf} << (#{tmp}).to_s;\n"
          elsif is_comment
            ret << "# #{tmp}\n"
          else
            ret << tmp << ";\n"
          end
          rb = embed = is_comment = is_single = is_block = false
          tmp.clear

        else
          tmp << drop(ss,1)
        end
    

      else # static

        unless ss =~ r0
          tmp << drop(ss,1)
        else

          drop(ss,$1.size) if $1
          drop(ss,$2.size) if $2

          rb = true

          # if tmp != ''
          #   ret << "#{ibuf} << #{tmp.inspect};\n"
          # end

          drop(ss,2)

          if ss[0] == '-'
            is_cut_blanks = true
            drop(ss,1)
          end
          
          if ss[0] == '*'
            is_block = true
            drop(ss,1)
          end

          if ss[0] == '.'
            is_single = true
            drop(ss,1)
          end

          if ss[0] == '='
            embed = true
            drop(ss,1)
          end

          if ss[0] == '#'
            is_comment = true
            drop(ss,1)
          end

          if is_cut_blanks
            tmp = tmp.match(/\A(.*?)(\r?\n[ \t]*)?\z/m)[1]
            is_cut_blanks = false
          end

          if tmp != ''
            ret << "#{ibuf} << #{tmp.inspect};\n"
          end

          tmp.clear
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
    "# encoding: utf-8\n#{buf} = +'';\n" + ret + buf
  else
    ["#{ibuf} = +'';\n" + ret, ss]
  end
end
