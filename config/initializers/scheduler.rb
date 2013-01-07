scheduler = Rufus::Scheduler.start_new

# Retrieve near-realtime quotes

# TODO: stop the scheduler when the market is closed
#       (from 9:00 to 18:00)
scheduler.every '10s' do
	puts " = #{Time.now} => Retrieve Yahoo Finance data"
	Portfolio.new.quotes.each do |symbol, data|
		# TODO: store the data on a new model for future analysis
		puts "#{data.name} => #{data.value}"
	end
end 