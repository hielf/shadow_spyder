#! /usr/bin/env ruby
# encoding: utf-8

require 'nokogiri'
require 'open-uri'
require 'dbi'
require 'roo'
require 'rest-client'


# Fetch and parse HTML document


def init
  key_word_list = Roo::Spreadsheet.open('./key.xlsx').sheet(0).column(1)
  @root = 'https://www.youtube.com'
  @dbh = DBI.connect("DBI:Mysql:cars_video:localhost","root", "user")
  @dbh.do('set names utf8')
  def get_video_info(href,key)
    response = RestClient.get(href)
    html = response.body
    sth = @dbh.prepare("insert into video(src,name,author,pv,video_duration,key_word) values(?,?,?,?,?,?)")
    v = @dbh.prepare("select * from video where src = ?")
    s = @dbh.prepare("select name,video_duration from video where name = ? and video_duration = ?")
    doc = Nokogiri::HTML(html)
    if doc.css('.item-section>li').count > 1
      doc.css('.item-section>li').each do |item|
        begin
          href = item.search('.yt-lockup-title a').attr('href')
          title = item.search('.yt-lockup-title a').text.to_s
          # views_count = item.search('.yt-lockup-meta-info').children[1].text.scan(/\d/).to_s
          views_count = item.search('.yt-lockup-meta-info').children[1].text.gsub!(/\D/,"")
          puts views_count
          duration = item.search('.video-time').text
          author = item.search('.g-hovercard').text
          keyWord = key
        rescue
          puts("有错误")
        end

        v.execute(@root + href)
        s.execute(title,duration)

        if v.fetch_all.empty? and s.fetch_all.empty?
          if views_count.to_i>2000
            begin
              sth.execute(@root + href,title,author,views_count,duration,keyWord)
              puts("加入成功")
            rescue DBI::DatabaseError => e
              puts("数据有错误")
            end
          else
            puts("浏览数小于2000")
          end
        else
          puts("已存在这条数据")
        end
      end
      v.finish
      s.finish
      sth.finish
      @dbh.commit

      if doc.css('.branded-page-box a').count>0
        puts(doc.css('.branded-page-box a').last.search('span').text.to_i)
        if doc.css('.branded-page-box a').last.search('span').text.to_i == 0
          next_page = doc.css('.branded-page-box a').last.attr('href')
          puts next_page
          puts("+++++++++++++++++++++++++ new page +++++++++++++++++++")
          get_video_info(@root + next_page,key)
        end
      end
    end
  end


  key_word_list = @dbh.prepare("select * from key_words")
  key_word_list.execute()
  key_word_list.fetch do |row|
    key = row[1].force_encoding('utf-8').split('|').join("")
    url = @root +"/results?q=#{key}&sp=EgIIBUgA6gMA"
    url = URI.encode(url)
    puts("================new key_word #{key}===============")
    get_video_info(url,key)

  end

  # begin
  #   ssl.connect_nonblock
  # rescue IO::WaitReadable
  #   IO.select([s2])
  #   retry
  # rescue IO::WaitWritable
  #   IO.select(nil, [s2])
  #   retry
  # end

end

init()
