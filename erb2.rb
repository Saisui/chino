def erb2(ss, trim = false, buf: "_buf",
  block: %w[{% %}], embed: %w[{{ }}], comment: %w[{# #}]
)
  sz_blk_0 = block[0].size
  sz_blk_1 = block[1].size
  sz_emb_0 = embed[0].size
  sz_emb_1 = embed[1].size

  comment ||= %W[#{block[0]}# #{block[1]}]
  block = block.map {|s| s.gsub(/[\{\[\(\)\]\}]/) { "\\"+_1 } }
  embed = embed.map {|s| s.gsub(/[\{\[\(\)\]\}]/) { "\\"+_1 } }
  comment = comment.map {|s| s.gsub(/[\{\[\(\)\]\}]/) { "\\"+_1 } }

  ret = ''

  r = trim ? /(?:\n *)?(#{block[0]}.*?#{block[1]})|(#{embed[0]}.*?#{embed[1]})|(?:\n *)?(#{comment[0]}.*?#{comment[1]})/
           : /(#{block[0]}.*?#{block[1]})|(#{embed[0]}.*?#{embed[1]})|(#{comment[0]}.*?#{comment[1]})/


  r_cmt  = /^#{comment[0]}.*#{comment[1]}$/
  r_emb  = /^#{embed[0]}.*#{embed[1]}$/
  r_blk  = /^#{block[0]}.*#{block[1]}$/

  ss.split(@r).each do |s|
    case s
    when r_emb
      ret << "#{buf} << (#{s[sz_emb_0...-sz_emb_1]}).to_s;\n"
    when r_cmt
    when r_blk
      ret << s[sz_blk_0...-sz_blk_1] << ";\n"
    else
      ret << "#{buf} << #{s.inspect};\n"
    end
  end
  "# encoding: UTF-8\n#{buf} = '';\n" + ret + buf
end
