namespace :db do

  desc "Create the transactions in db/data/transactions.json"
  task :create_transactions => :environment do
  	file         = Dir.glob('db/data/transactions.json').first
  	data         = File.open(file, 'rb').read
  	transactions = ActiveSupport::JSON.decode(data)['transactions']

  	puts " = Create transactions in #{file}"

 	transactions.each do |transaction|
 	  Transaction.create({
 	    :transaction_type => transaction['type'],
 		:amount           => transaction['amount'],
 		:created_at       => Time.zone.parse(transaction['created_at'])
 	  })
 	end
  end

end