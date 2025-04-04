def erb ss, buf: '_buf'
  ret = ''
  r = /(<%%)|(%%>)|(?:\n *)?(<%-\*?=?.*?%>)|(<%\*=?.*?%>)|(<%=?.*?%>)/m
  i = 0
  blks = []
  ss.split(r).each do |s|
    bufi  = buf + (i.zero? ? '' : (i-1).to_s)
    bufii = buf + (i.zero? ? '' : i.to_s)
    case s
    when /\A<%%|%%>/m
      ret << "#{bufi} << #{s.gsub('%%','%').inspect};\n"
    when /\A(<%-?\*) *(?:end|\})/m
      ret << "#{bufii};\n"
      ret << s[$1.size...-2] << ";\n"
      if blks.pop
        ret << "#{buf} << #{bufi};\n"
      end
      i -= 2
    when /\A(<%-?\*=)/m
      i += 2
      bufi  = buf + (i.zero? ? '' : (i-1).to_s)
      bufii = buf + (i.zero? ? '' : i.to_s)
      ret << "#{bufi} = #{s[$1.size...-2]};\n"
      ret << "#{bufii} = ''" << ";\n"
      blks.push true
    when /\A(<%-?\*)/m
      i += 2
      bufi  = buf + (i.zero? ? '' : (i-1).to_s)
      bufii = buf + (i.zero? ? '' : i.to_s)
      ret << s[$1.size...-2] << ";\n"
      ret << "#{bufii} = ''" << ";\n"
      blks.push false
    when /\A(<%-?=)/m
      ret << "#{bufii} << (#{s[$1.size...-2]}).to_s;\n"
    when /\A<%#/m, ''
    when /\A(<%-?)/m
      ret << s[$1.size...-2] << ";\n"
    else
      ret << "#{bufii} << #{s.inspect};\n"
    end
  end
  "# encoding: UTF-8\n#{buf} = '';\n" + ret + buf
end
