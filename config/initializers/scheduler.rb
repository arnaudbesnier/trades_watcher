scheduler = Rufus::Scheduler.start_new

# Avoid scheduler for Rails console
if !defined? Rails::Console
  # Retrieve near-realtime quotes
  # when the market is opened (from 9:00 to 18:00)
  scheduler.cron '* 9-18 * * 1-5 Europe/Paris' do
    now = Time.now
    puts " = #{now} => Retrieve Yahoo Finance data\n\n"
    QuotesRetriever.new
  end
end