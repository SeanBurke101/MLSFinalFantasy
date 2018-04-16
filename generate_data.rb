require 'watir'

Selenium::WebDriver::Chrome.driver_path = "./chromedriver.exe"
browser = Watir::Browser.new

browser.goto 'https://fantasy.mlssoccer.com/#stats-center/player-profile/86140'
player_html = browser.section(:class => 'player-select-item').html
player_list = player_html.scan(/\">(.*)<\/a>/i)
number_of_players = player_list.length
File.open("MLS_STATES.csv", "a") do |f|
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
    rounds = browser.div(:xpath => '//*[@id="player-content"]/div/div[3]/div[1]/div[2]/div[1]/div[2]').text.gsub(/\./,'').gsub(/\n/,"@").scan(/(\d+)@([a-zA-Z]+\s?[a-zA-Z]+?\s?[a-zA-Z]+?\s?[a-zA-Z]+?\s?)@(-?\d+|DNP|\d+|-)/)
    player_points_html = browser.div(:xpath => '//*[@id="player-content"]/div/div[3]/div[1]/div[2]').html.to_s.gsub(/\s+/, '')
    player_points_html = browser.div(:xpath => '//*[@id="js-scrolling-block"]/div[3]').htm
    round_details = player_points_html.gsub(/\n/,'').gsub(/\t/,'').gsub(/\\/,'').gsub(/\//,'').gsub(/\"/,'').gsub(/\(/,'').gsub(/\)/,'').gsub(/-/,'').scan(/<div title=\s?\w+?\s?\w+?\s?\w+?\s?\w+?\s?\w+?><p>(\d+?)?<p><p>(\d+?)?<p>/)
    number_of_rounds = round_details.length/25
    round_details_string = ''
    dnp_offset = 0
    for i in 0..number_of_rounds-2
      while(rounds[dnp_offset][2] =~ /DNP/i)
        dnp_offset += 1
      end
      round_details_string += rounds[dnp_offset].join(',') + ','
      for x in (i*25)..(((i+1)*25)-1)
        round_details_string += round_details[x].join('|') + ','
      end
    end
    rounds.each do |round|
      f.puts("#{name},#{team},#{position},#{previous_points},#{worth},#{status},#{browser.url},#{round.join(',')}")
    end
  rescue Exception => e
    browser.close
    browser = Watir::Browser.new
    browser.goto 'https://fantasy.mlssoccer.com/#stats-center/player-profile/86140'
    i -= 1
  end
  end
end
browser.close