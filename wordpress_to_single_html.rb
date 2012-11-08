#!/usr/bin/env ruby

require 'rubygems'
require 'nokogiri'

#doc = Nokogiri::XML(File.open("jakgoes2mw.wordpress.2012-11-08.xml")) 
doc = Nokogiri::XML(File.open(ARGV[0])) 

puts '<html><meta http-equiv="Content-Type" content="text/html; charset=UTF-8" /><body>'
doc.css('item').each do |i|
  if i.at('wp|post_type').content == 'post'
    puts "<h1>#{i.at('title').content}</h1>"
    puts "<p class=\"_content\">#{i.at('content|encoded').content}</p>"
    puts "<p class=\"_post_date\">#{i.at('wp|post_date').content}</p>"
    i.css('wp|comment').each do |c|
#      puts "<p class=\"_comment_content\">#{c.at('wp|comment_content').content}</p>"
#      puts "<p class=\"_comment_author_date\">#{c.at('wp|comment_author').content} #{c.at('wp|comment_date').content}</p>"
      puts "<p class=\"_author_comment\">#{c.at('wp|comment_author').content}: #{c.at('wp|comment_content').content}</p>"
    end
  end
end
puts '</body></html>'
