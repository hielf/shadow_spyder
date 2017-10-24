require 'rubygems'
require 'headless'
require 'selenium-webdriver'
require 'watir'
# require 'rails'

file = File.open("/var/www/cheshipinSpyder/current/log/test.log", "w")
file.write  "test started #{Time.now}/n"
headless = Headless.new #(display: 100, reuse: true, destroy_at_exit: false)
headless.start
file.write  "test headless started #{Time.now}/n"
href = "http://v.youku.com/v_show/id_XMzAzMDk1NTcyNA==.html?spm=a2h0k.8191407.0.0&from=s1.8-1-1.2&f=29265257"
browser = Watir::Browser.new :chrome, headless: true
browser.goto(href)
# browser = Selenium::WebDriver.for :chrome
# browser.navigate.to href
# browser.execute_script("window.scrollBy(0,500)")
sleep 5
file.write  "test #{browser.title} finished #{Time.now}/n"
browser.close
headless.destroy
file.write "test end #{Time.now}/n"
file.close
