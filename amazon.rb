#!/bin/env ruby
# encoding: utf-8

require 'rubygems'
require 'mechanize'
require 'highline/import'

# Will use global variables $tld, currency, overviewtext, nexttext
# They are used to identify different texts in different languages
# (eg. $overviewtext = 'Printable Order Summary' if UK is chosen,
# because that's the text of the link to a printable order summary
# on amazon.co.uk)

def get_order_links(agent, page, order_links)
	links = page.links_with(:text => $overviewtext)
	order_links += links

	next_link = page.link_with(:text => $nexttext)

	if(next_link != nil) then
		get_order_links(agent, agent.click(next_link), order_links)
	end
end

total_sum = 0.0

email = ask('E-Mail:')
password = ask('Password:') { |q|
	q.echo = '*'
}


# Dear amazon.com redesign,
# FUCK YOU!
# Sincerely, Pascal
puts "1) Germany 2) UK"
country = ask('Country: ', Integer) { |q| q.in = 1..2 }

case country
	when 2
		$tld = 'co.uk'
		$currency = '£'
		$overviewtext = 'Printable Order Summary'
		$pricedelimiter = '.'
		$thousandseperator = ','
		$nexttext = 'Next »'
	else
		$tld = 'de'
		$currency = 'EUR '
		$overviewtext = 'Bestellübersicht drucken'
		$pricedelimiter = ','
		$thousandseperator = '.'
		$nexttext = 'Weiter→'
end

open('amazon.csv', 'w') { |f|
	f.puts "year, amount"
}

a = Mechanize.new { |agent|
	agent.user_agent_alias = 'Mac Safari'
}
# Disable SSL verification to make it work under windows without problems
a.agent.http.verify_mode = OpenSSL::SSL::VERIFY_NONE

puts 'Now scanning https://amazon.' + $tld + '/'

a.get('https://www.amazon.' + $tld + '/gp/your-account/order-history/') do |page|
		logged_in_page = page.form_with(:name => 'signIn') do |f|
			f.email = email
			f.password = password
		end.click_button

	years = Array.new

	select_form = logged_in_page.form_with(:id => 'timePeriodForm')

	if (select_form == nil)
		puts "Seems like I could not log you in. I'm sorry :("
		Process.exit
	end

	select_form.field_with(:name => 'orderFilter').options.each do |option|

		if( option.value == 'select-another' or option.value == 'last30' or option.value == 'months-6') then
			next
		end

		option.select

		year_page = select_form.submit

		count = year_page.search(".//span[@class='num-orders']")
		year = year_page.search(".//span[@class='a-dropdown-prompt']")

		puts "Year " + year.text + ", " + count.text + " orders"
		print "\t"

		year_sum = 0.0
		order_links = Array.new

		get_order_links(a, year_page, order_links)

		order_links.each do |link|
			order_page = a.click(link)

			money_str = order_page.search(".//body//table[1]/tr/td/table/tr[3]/td/b").text

			if(money_str.index($currency) == nil) then
				money_str = order_page.search(".//body//table[1]/tr/td/table/tr[4]/td/b").text

				if(money_str.index($currency) == nil) then
					puts $currency + " not found. Link: " + link.href
					puts "title " + order_page.title

					next
				end
			end

			# multi-line result, select currency until end-of-string
			money_str = money_str[money_str.index($currency)..-1]

			money_str[$currency]= ''

			# Delete all thousand seperators
			if(money_str.index($thousandseperator) != nil) then
				money_str[$thousandseperator]=''
			end

			money_str[$pricedelimiter]= '.'

			eurs = money_str.to_f

			total_sum = total_sum + eurs
			year_sum = year_sum + eurs

			print eurs
			print " "
			STDOUT.flush
		end

		puts "Done. Year total: " + year_sum.to_s
        
        	open('amazon.csv', 'a') { |f|
            		f.puts year.text + "," + year_sum.to_s
        	}
	end
end


puts "Done. Total amount: " + total_sum.to_s
