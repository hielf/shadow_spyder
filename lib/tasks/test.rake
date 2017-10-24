namespace :publish do
  task :test => :environment do
    require 'rubygems'
    require 'headless'
    require 'selenium-webdriver'
    require 'watir'
    Rails.logger.warn  "test started #{Time.now}"
    headless = Headless.new #(display: 100, reuse: true, destroy_at_exit: false)
    headless.start
    Rails.logger.warn  "test headless started #{Time.now}"
    # system("xvfb-run java -Dwebdriver.chrome.driver=/usr/local/bin/chromedriver -jar /usr/local/bin/selenium-server-standalone.jar")
    href = "http://v.youku.com/v_show/id_XMzAzMDk1NTcyNA==.html?spm=a2h0k.8191407.0.0&from=s1.8-1-1.2&f=29265257"
    browser = Watir::Browser.new :chrome, headless: true
    browser.goto(href)
    # # browser.goto("http://www.google.com")
    # # browser = Selenium::WebDriver.for :phantomjs
    # # browser.navigate.to 'http://google.com'
    # browser.driver.execute_script("window.scrollBy(0,500)")
    sleep 5
    Rails.logger.warn  "test #{browser.title} finished #{Time.now}"
    browser.close
    headless.destroy
    Rails.logger.warn "test end #{Time.now}"

  end
end
