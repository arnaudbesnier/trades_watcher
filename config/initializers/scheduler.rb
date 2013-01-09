scheduler = Rufus::Scheduler.start_new

def market_is_opened? datetime
	week_day    = datetime.wday
	hour        = datetime.hour
	is_week_day = [1,2,3,4,5].include?(datetime.wday) # From Monday to Friday
	
	is_week_day && hour > 9 && hour < 18
end

# Retrieve near-realtime quotes

# TODO: stop the scheduler when the market is closed
#       (from 9:00 to 18:00)
scheduler.every '10s' do
	now = Time.now
	if market_is_opened? now
		puts " = #{now} => Retrieve Yahoo Finance data\n\n"
		Portfolio.new
		puts " ===========================================\n\n"
	else
		puts " = #{now} => The market is currently closed"
	end
end 