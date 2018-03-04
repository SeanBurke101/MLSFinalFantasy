require 'watir'

Selenium::WebDriver::Chrome.driver_path = "./chromedriver.exe"
browser = Watir::Browser.new

browser.goto 'https://fantasy.mlssoccer.com/#stats-center/player-profile/86140'
player_html = browser.section(:class => 'player-select-item').html
player_list = player_html.scan(/\">(.*)<\/a>/i)
number_of_players = player_list.length
puts number_of_players
for i in 1..number_of_players
  begin
    browser.input(:class => ['search js-input-player base-input']).click
    browser.li(:xpath => "//*[@id=\"filter\"]/div/div[2]/section/div/div/div/div/li[#{i}]").click
    while 1
      sleep(1)
      break if !browser.i(:xpath => '//*[@id="loading"]/i').visible?
      sleep(1)
    end
    name = browser.p(:class => ["profile-name"]).text
    team = browser.p(:class => ["player-team"]).text
    position_worth = browser.p(:class => ["player-pos uppercase"]).text.split(' ')
    position = position_worth[0]
    worth = position_worth[-1]
    status = browser.p(:class => ["player-pos uppercase"]).html.scan(/<i class=\"(.*)\">/)[0][0]
    previous_points = browser.p(:xpath => '//*[@id="player-content"]/div/div[2]/div/div/div[1]/div[3]/p[2]').text
    puts("#{name},#{team},#{position},#{previous_points},#{worth},#{status}")
  rescue
    browser.close
    browser = Watir::Browser.new
    browser.goto 'https://fantasy.mlssoccer.com/#stats-center/player-profile/86140'
    i -= 1
  end
end
browser.close