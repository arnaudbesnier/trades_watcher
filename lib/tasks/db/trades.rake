namespace :db do

  desc "Create the trades in db/data/trades.json"
  task :create_trades => :environment do
  	file   = Dir.glob('db/data/trades.json').first
  	data   = File.open(file, 'rb').read
  	trades = ActiveSupport::JSON.decode(data)['trades']

  	puts " = Create trades in #{file}"

 	trades.each do |trade|
 	  Trade.create({
 	    :company_id       => Company.find_by_symbol(trade['company']).id,
 		:shares           => trade['shares'],
 		:opened_at        => Time.zone.parse(trade['opened_at']),
 		:closed_at        => trade['closed_at'] ? Time.zone.parse(trade['closed_at']) : nil,
 		:price_bought     => trade['price_bought'],
 		:price_sold       => trade['price_sold'],
 		:commission_total => trade['commission_total'],
 		:taxes            => trade['taxes']
 	  })
 	end
  end

end