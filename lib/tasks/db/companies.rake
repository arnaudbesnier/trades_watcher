namespace :db do

  desc "Create the companies in db/data/companies.json"
  task :create_companies => :environment do
  	file      = Dir.glob('db/data/companies.json').first
  	data      = File.open(file, 'rb').read
  	companies = ActiveSupport::JSON.decode(data)['companies']

  	puts " = Create companies in #{file}"

 	companies.each do |company|
      sector = Sector.find_or_create_by_name(company['sector'])

 	  Company.create({
 	    :name      => company['name'],
 		:symbol    => company['symbol'],
 		:sector_id => sector.id
 	  })
 	end
  end

end