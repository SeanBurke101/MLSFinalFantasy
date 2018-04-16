require 'watir'

people_ids = '40093
41902
42040
39672
39674
37003
36164
41245
36871
41078
35547
34954
41059
34183
33101
36099
39413
36309
36089
34170
29569
30823
27910
28527
35098
33231
26090
26775
26780
23335
24937
25338
25290
21001
27754
23019
18851
19454
18058
17200
18166
24086
19949
12539
19069
15023
12112
24085
35090
8172
8618
8448
8225
7359
8522
10953
4247
36517
15025
4755
23660
7380
5014
5211
10499
1325
5749
8060
2946
1313
5208
1305
7287
5209
15028
4599
4598
14882
4766
5711
5759
4656
4653
4654
4767
26127
4166
5210
4650
4601
4649
4651
7286
4648
7282
4371
4306
2836
5277
2632
4774
5022
5734
4495
2336
7446
2337
4768
13255
7110
2334
5021
4772
4490
4769
2339
2343
1321
2342
10566
4916
4794
4787
4773
2341
33530
2888
2511
4600
4486
4485
3958
2344
2360
4785
2328
2332
10362
2359
2349
4915
4025
2358
2357
4784
29634
13159
4996
2346
35884
2355
8046
2353
4783
2352
4781
29647
4798
4779
4778
22089
7350
2351
31621
7351
4777
2686
2350
3974
23404
28901
23627
2345
4154
4796
2684'



people_ids = people_ids.split(/\n/)

p people_ids


def get_value_in_column(column,key)
  column.rows.each do | row |
    if(row[0].text == key)
      return row[1].text
    end
  end
  return "#{key} not found"
end

Selenium::WebDriver::Chrome.driver_path = "./chromedriver.exe"
browser = Watir::Browser.new

browser.goto 'https://www.findthemissing.org/en'
sleep 3
while(!browser.select(:id => 'search_Circumstances.StateLKA').exists?)
  sleep 1
end
state_select_list = browser.select(:id => 'search_Circumstances.StateLKA')
# california 5 |||
states = state_select_list.options[6..6]
previous_name = nil
states.each do | state_option |
  state = state_option.text
  File.open("#{state}.csv", "w+") do |f|
    state_select_list.select(state)
    browser.input(:xpath => '/html/body/div[2]/div[3]/div[2]/div[2]/form/table/tbody/tr[5]/td[2]/input').click
    while(!browser.tbody(:xpath => '//*[@id="list"]/tbody').exists?)
      sleep 1
    end
    number_of_pages = browser.span(:id => 'sp_1').text.split(' ')[-1].to_i
    for i in 1..number_of_pages
      for x in 1..10
        while(!browser.tbody(:xpath => '//*[@id="list"]/tbody').exists?)
          sleep 1
        end
        browser.input(:xpath => '//*[@id="pager"]/input[3]').to_subtype.clear
        browser.input(:xpath => '//*[@id="pager"]/input[3]').send_keys(i.to_s)
        browser.send_keys :enter
        person_section = browser.tbody(:xpath => '//*[@id="list"]/tbody')
        sleep 2
        while(!person_section.exists? and !(previous_name == person_section[x][1].text))
          sleep 1
        end
        sleep 2
        person_row = person_section[x]
        while(true)
          if(person_section.exists?)
            if(person_section[0].exists?)
              if(person_section[x].exists?)
                if(person_section[0].exists?)
                  break
                end
              end
            end
          end
        end
        previous_name = person_section[x][1].text
        if(person_row.exists?)
          person_row.click
          while(!browser.tbody(:xpath => '//*[@id="case_information"]/div[1]/table/tbody').exists?)
            sleep 1
          end
          column1 = browser.tbody(:xpath => '//*[@id="case_information"]/div[1]/table/tbody')
          # p column1.html
          first_name = get_value_in_column(column1,'First name')
          last_name = get_value_in_column(column1,'Last name')
          date_last_seen = get_value_in_column(column1,'Date last seen')
          column2 = browser.tbody(:xpath => '//*[@id="case_information"]/div[2]/table/tbody')
          date_entered = get_value_in_column(column1,'Date entered')
          age_last_seen = get_value_in_column(column2,'Age last seen')
          race = get_value_in_column(column2,'Race')
          ethnicity = get_value_in_column(column2,'Ethnicity')
          sex = get_value_in_column(column2,'Sex')
          # first_name = browser.td(:xpath => '//*[@id="case_information"]/div[1]/table/tbody/tr[2]/td[2]').text
          # last_name = browser.td(:xpath => '//*[@id="case_information"]/div[1]/table/tbody/tr[4]/td[2]').text
          # date_last_seen = browser.td(:xpath => '//*[@id="case_information"]/div[1]/table/tbody/tr[6]/td[2]').text
          # date_entered = browser.td(:xpath => '//*[@id="case_information"]/div[1]/table/tbody/tr[7]/td[2]').text
          # age_last_seen = browser.td(:xpath => '//*[@id="case_information"]/div[2]/table/tbody/tr[1]/td[2]').text
          # race = browser.td(:xpath => '//*[@id="case_information"]/div[2]/table/tbody/tr[3]/td[2]').text
          # ethnicity = browser.td(:xpath => '//*[@id="case_information"]/div[2]/table/tbody/tr[4]/td[2]').text
          # sex = browser.td(:xpath => '//*[@id="case_information"]/div[2]/table/tbody/tr[5]/td[2]').text
          browser.a(:xpath => '/html/body/div[2]/div[3]/div[1]/dl[3]/dt[2]/a').click
          while(!browser.tbody(:xpath => '//*[@id="circumstances"]/div/table/tbody').exists?)
            sleep 1
          end
          column3 = browser.tbody(:xpath => '//*[@id="circumstances"]/div/table/tbody')
          city = get_value_in_column(column3,'City')
          state = get_value_in_column(column3,'State')
          zip = get_value_in_column(column3,'Zip code')
          county = get_value_in_column(column3,'County')
          # city = browser.td(:xpath => '//*[@id="circumstances"]/div/table/tbody/tr[1]/td[2]').text
          # state = browser.td(:xpath => '//*[@id="circumstances"]/div/table/tbody/tr[2]/td[2]').text
          # zip = browser.td(:xpath => '//*[@id="circumstances"]/div/table/tbody/tr[3]/td[2]').text
          # county = browser.td(:xpath => '//*[@id="circumstances"]/div/table/tbody/tr[4]/td[2]').text
          browser.a(:xpath => '/html/body/div[2]/div[3]/div[1]/dl[3]/dt[11]/a').click
          while(!browser.tbody(:xpath => '//*[@id="police_information"]/div[1]/table/tbody').exists?)
            sleep 1
          end
          column4 = browser.tbody(:xpath => '//*[@id="police_information"]/div[1]/table/tbody')
          date_reported = get_value_in_column(column4,'Date reported')
          column5 = browser.tbody(:xpath => '//*[@id="police_information"]/div[2]/table/tbody')
          jurisdiction = get_value_in_column(column5,'Jurisdiction')
          agency= get_value_in_column(column5,'Agency')
          # date_reported = browser.td(:xpath => '//*[@id="police_information"]/div[1]/table/tbody/tr[7]/td[2]').text
          # jurisdiction = browser.td(:xpath => '//*[@id="police_information"]/div[2]/table/tbody/tr[1]/td[2]').text
          # agency = browser.td(:xpath => '//*[@id="police_information"]/div[2]/table/tbody/tr[2]/td[2]').text
          f.puts(first_name+','+last_name+','+date_last_seen+','+date_entered+','+age_last_seen+','+race+','+ethnicity+','+sex+','+city+','+state+','+zip+','+county+','+date_reported+','+jurisdiction+','+agency)
          puts(first_name+','+last_name+','+date_last_seen+','+date_entered+','+age_last_seen+','+race+','+ethnicity+','+sex+','+city+','+state+','+zip+','+county+','+date_reported+','+jurisdiction+','+agency)
        else
          break
        end
        browser.back
      end
    end
    browser.goto 'https://www.findthemissing.org/en'
  end
end
browser.close