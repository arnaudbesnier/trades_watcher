namespace :db do

  desc "Create the orders in db/data/orders.json"
  task :create_orders => :environment do
  	file   = Dir.glob('db/data/orders.json').first
  	data   = File.open(file, 'rb').read
  	orders = ActiveSupport::JSON.decode(data)['orders']

  	puts " = Create orders in #{file}"

 	orders.each do |order|
 	  Order.create({
 	    :company_id  => Company.find_by_symbol(order['company']).id,
 		:shares      => order['shares'],
 		:order_type  => Order::TYPE_IDS[order['order_type'].to_sym],
 		:price       => order['price'],
 		:commission  => order['commission'],
 		:taxes       => order['taxes'],
 		:created_at  => Time.zone.parse(order['created_at']),
 		:executed_at => order['executed_at'].nil? ? nil : Time.zone.parse(order['executed_at'])
 	  })
 	end
  end

end