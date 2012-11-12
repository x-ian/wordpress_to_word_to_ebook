#!/usr/bin/env ruby

require 'rubygems'
require 'nokogiri'

doc = Nokogiri::XML(File.open(ARGV[0])) 

# some simple html stuff
puts '<html><meta http-equiv="Content-Type" content="text/html; charset=UTF-8" /><body>'
# get all items from the xml
items = doc.css('item').sort{|x,y| x.at('wp|post_date').content <=> y.at('wp|post_date').content}
items.each do |i|
  if (i.at('wp|post_type').content == 'post' && i.at('wp|status').content == 'publish')
#    puts "<hr/>"
    puts "<h4 class=\"_header\">#{i.at('title').content}</h4>"
    content = i.at('content|encoded').content
    # convert caption tags from wordpress into ordinary paragraphs (otherwise they won't be converted)
    # note that here 2 <p> tags are nested and technically produce invaid html
    content.gsub!(%r'\[caption.* caption=.*\"\]') do |c|
      t = c.match(%r' caption=\".*?\"').to_s
      "<p class=\"_caption\">&darr; " + t.slice(10, t.length-11) + " &darr;</p>"
    end
    # remove closing [/caption] tag
    content.gsub!('[/caption]', '')
    # convert img titles (for mouseover) into ordinary paragraphs
    # note that here 2 <p> tags are nested and technically produce invaid html
    content.gsub!(%r'<img .* title=.*>') do |c|
      next c if c.include? "IMG_"
      next c if c.index(%r'P.*(\d\d\d\d\d\d\d)') != nil
      t = c.match(%r' title=\".*?\"').to_s
      t = "<p class=\"_caption\">&uarr; " + t.slice(8, t.length-9) + " &uarr;</p>"
      "#{c} #{t}"
    end
    # get full resolution picture from wordpress be removing preview parameter w=xyz
    content.gsub!(%r'\.jpg\?w=(\d+)"', '.jpg"')
    puts "<p class=\"_content\">#{content}</p>"
    puts "<p class=\"_post_date\">(#{i.at('wp|post_date').content})</p>"
    first_comment = true
    i.css('wp|comment').each do |c|
      if first_comment
        puts "<p>______</p>"
        first_comment = false
      end
#      puts "<p class=\"_comment_content\">#{c.at('wp|comment_content').content}</p>"
#      puts "<p class=\"_comment_author_date\">#{c.at('wp|comment_author').content} #{c.at('wp|comment_date').content}</p>"
      puts "<p class=\"_author_comment\">#{c.at('wp|comment_author').content}: #{c.at('wp|comment_content').content}</p>"
    end
  end
end
puts '</body></html>'
