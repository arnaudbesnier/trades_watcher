namespace :db do

  desc "Create the dividends in db/data/dividends.json"
  task :create_dividends => :environment do
  	file      = Dir.glob('db/data/dividends.json').first
  	data      = File.open(file, 'rb').read
  	dividends = ActiveSupport::JSON.decode(data)['dividends']

  	puts " = Create dividends in #{file}"

 	dividends.each do |dividend|
 	  Dividend.create({
 	    :company_id  => Company.find_by_symbol(dividend['company']).id,
 		:shares      => dividend['shares'],
 		:received_at => Time.zone.parse(dividend['received_at']),
 		:amount      => dividend['amount'],
 		:taxes       => dividend['taxes']
 	  })
 	end
  end

end