require 'watir'

Selenium::WebDriver::Chrome.driver_path = "./chromedriver.exe"
browser = Watir::Browser.new

browser.goto 'https://fantasy.mlssoccer.com/#stats-center/player-profile/86140'
player_html = browser.section(:class => 'player-select-item').html
player_list = player_html.scan(/\">(.*)<\/a>/i)
number_of_players = player_list.length
puts number_of_players
for i in 2..number_of_players
  browser.input(:class => 'search js-input-player base-input').click
  browser.li(:xpath => "//*[@id=\"filter\"]/div/div[2]/section/div/div/div/div/li[#{i}]").click
  while 1
    sleep(1)
    break if !browser.i(:xpath => '//*[@id="loading"]/i').visible?
    puts(browser.i(:xpath => '//*[@id="loading"]/i').visible?)
    sleep(1)
  end
end
sleep(100)
browser.close