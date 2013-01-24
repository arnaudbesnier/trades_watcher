namespace :db do

  desc "Create the companies in db/data/companies.json"
  task :create_companies => :environment do
  	file      = Dir.glob('db/data/companies.json').first
  	data      = File.open(file, 'rb').read
  	companies = ActiveSupport::JSON.decode(data)['companies']

  	puts " = Create companies in #{file}"

 	companies.each do |company|
 	  Company.create({
 	    :name   => company['name'],
 		:symbol => company['shares']
 	  })
 	end
  end

end