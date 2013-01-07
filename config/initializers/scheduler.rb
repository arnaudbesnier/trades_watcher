scheduler = Rufus::Scheduler.start_new

scheduler.every '1m' do
	puts '====> retrieve_data'
end 