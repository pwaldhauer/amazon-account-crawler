require 'rubygems'
require 'mechanize'
require 'highline/import'

def get_order_links(agent, page, order_links)
	links = page.links_with(:text => 'Übersicht anzeigen')
	links.each { |link|
		order_links.push(link)
	}

	next_link = page.link_with(:text => 'Weiter »')		

	if(next_link != nil) then
		get_order_links(agent, agent.click(next_link), order_links)
	end
end

total_sum = 0.0

email = ask('E-Mail:')
password = ask('Password:') { |q|
	q.echo = '*'	
}

a = Mechanize.new { |agent|
	agent.user_agent_alias = 'Mac Safari'
}
# Disable SSL verification to make it work under windows without problems
a.agent.http.verify_mode = OpenSSL::SSL::VERIFY_NONE

a.get('http://amazon.de/') do |page|
	login_page = a.click(page.link_with(:text => 'Melden Sie sich an'))

	logged_in_page = login_page.form_with(:id => 'ap_signin_form') do |f|
		f.email = email
		f.password = password
	end.click_button

	account_page = a.click(logged_in_page.link_with(:text => 'Mein Konto'))	

	orders_page = a.click(account_page.link_with(:text => 'Meine Bestellungen'))

	years = Array.new

	select_form = orders_page.form_with(:id => 'order-dropdown-form')
	select_form.field_with(:name => 'orderFilter').options.each do |option|

		if( option.value == 'select-another' or option.value == 'last30' or option.value == 'months-6') then
			next
		end

		option.select

		year_page = select_form.submit

		
		count = year_page.search(".//div[@class='num-results']/b[1]")
		year = year_page.search(".//div[@class='num-results']/b[2]")


		puts "Jahr " + year.text + ", " + count.text + " Bestellungen"
		print "\t"

		year_sum = 0.0
		order_links = Array.new

		get_order_links(a, year_page, order_links)

		order_links.each do |link|
			order_page = a.click(link)

			money_str = order_page.search(".//body/table[1]/tr[3]/td/b/nobr").text

			if(money_str.index('EUR ') == nil) then
				money_str = order_page.search(".//body/table[1]/tr[4]/td/b/nobr").text

				if(money_str.index('EUR ') == nil) then
					puts "EUR not found. Link: " + link.href
					puts "title " + order_page.title

					next
				end
			end

			money_str['EUR ']= ''

			if(money_str.index('.') != nil) then
				money_str['.']=''
			end

			money_str[',']= '.'
			
			eurs = money_str.to_f
			
			total_sum = total_sum + eurs
			year_sum = year_sum + eurs

			print eurs
			print " "
			STDOUT.flush
		end
		
		puts "Done. Year total: " + year_sum.to_s
	end
	
end


puts "Done. Total amount: " + total_sum.to_s
