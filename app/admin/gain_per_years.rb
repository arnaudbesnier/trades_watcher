#ActiveAdmin.register GainPerYear do
  
#  menu :priority => 3

#end

ActiveAdmin.register_page "GainPerYear" do
    menu :parent => "Dashboard"

    content do
      para "YEAR - TRADE GAINS - DIVIDENDS - DEPOSIT TOTAL - PERF YEAR - PERF TOTAL"
      Time.now.year.downto(2011) do |year|
        gain = GainPerYear.new(year)
        para "#{gain.year} - #{gain.trade_gains.to_f} - #{gain.dividends.to_f} - #{gain.deposits_total.to_f} - #{gain.value} - #{gain.performance_year} - #{gain.performance_total}"
      end
    end
  end 