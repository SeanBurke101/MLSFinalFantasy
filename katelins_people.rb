require 'watir'

Selenium::WebDriver::Chrome.driver_path = "./chromedriver.exe"
browser = Watir::Browser.new

browser.goto 'https://www.findthemissing.org/en'

state_select_list = browser.select(:id => 'search_Circumstances.StateLKA')
states = state_select_list.options[1..-1]
states.each do | state_option |
  state = state_option.text
  state_select_list.select(state)
  browser.input(:xpath => '/html/body/div[2]/div[3]/div[2]/div[2]/form/table/tbody/tr[5]/td[2]/input').click
  sleep(5)
  number_of_pages = browser.span(:id => 'sp_1').text.split(' ')[-1].to_i
  for i in 1..number_of_pages
    for x in 1..10
      browser.input(:xpath => '//*[@id="pager"]/input[3]').to_subtype.clear
      browser.input(:xpath => '//*[@id="pager"]/input[3]').send_keys(i.to_s)
      browser.send_keys :enter
      sleep 3
      person_section = browser.tbody(:xpath => '//*[@id="list"]/tbody')
      person_row = person_section[x]
      if(person_row.exists?)
        person_row.click
        sleep 3
        first_name = browser.td(:xpath => '//*[@id="case_information"]/div[1]/table/tbody/tr[2]/td[2]').text
        last_name = browser.td(:xpath => '//*[@id="case_information"]/div[1]/table/tbody/tr[4]/td[2]').text
        date_last_seen = browser.td(:xpath => '//*[@id="case_information"]/div[1]/table/tbody/tr[6]/td[2]').text
        date_entered = browser.td(:xpath => '//*[@id="case_information"]/div[1]/table/tbody/tr[7]/td[2]').text
        age_last_seen = browser.td(:xpath => '//*[@id="case_information"]/div[2]/table/tbody/tr[1]/td[2]').text
        race = browser.td(:xpath => '//*[@id="case_information"]/div[2]/table/tbody/tr[3]/td[2]').text
        ethnicity = browser.td(:xpath => '//*[@id="case_information"]/div[2]/table/tbody/tr[4]/td[2]').text
        sex = browser.td(:xpath => '//*[@id="case_information"]/div[2]/table/tbody/tr[5]/td[2]').text
        browser.a(:xpath => '/html/body/div[2]/div[3]/div[1]/dl[3]/dt[2]/a').click
        sleep 1
        city = browser.td(:xpath => '//*[@id="circumstances"]/div/table/tbody/tr[1]/td[2]').text
        state = browser.td(:xpath => '//*[@id="circumstances"]/div/table/tbody/tr[2]/td[2]').text
        zip = browser.td(:xpath => '//*[@id="circumstances"]/div/table/tbody/tr[3]/td[2]').text
        county = browser.td(:xpath => '//*[@id="circumstances"]/div/table/tbody/tr[4]/td[2]').text
        browser.a(:xpath => '/html/body/div[2]/div[3]/div[1]/dl[3]/dt[11]/a').click
        sleep 1
        date_reported = browser.td(:xpath => '//*[@id="police_information"]/div[1]/table/tbody/tr[7]/td[2]').text
        jurisdiction = browser.td(:xpath => '//*[@id="police_information"]/div[2]/table/tbody/tr[1]/td[2]').text
        agency = browser.td(:xpath => '//*[@id="police_information"]/div[2]/table/tbody/tr[2]/td[2]').text
        puts(first_name+','+last_name+','+date_last_seen+','+date_entered+','+age_last_seen+','+race+','+ethnicity+','+sex+','+city+','+state+','+zip+','+county+','+date_reported+','+jurisdiction+','+agency)
      else
        break
      end
      browser.back
      sleep 1
    end
  end
  break
  browser.goto 'https://www.findthemissing.org/en'
end
browser.close