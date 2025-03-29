# Shortest ERB Engine
# COPYRIGHT saisui@github
# LICENCE GPL 3.0
# GIMME MONEY
def erb ss, trim = false
  ret = ''
  r = trim ? /(?:\n *)?<(?=%)|%>/ : /<(?=%)|%>/
  ss.split(r).each do |s|
    case s
    when /^%=/
      ret << "_buf << (#{s[2..]}).to_s;\n"
    when /^%#/
    when /^%/
      ret << s[1..] << ";\n"
    else
      ret << "_buf << #{s.inspect};\n"
    end
  end
  "# encoding: UTF-8\n_buf = '';\n" + ret + '_buf'
end
