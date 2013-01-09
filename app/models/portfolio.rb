class Portfolio

	def initialize
		@companies = Trade.opened.map(&:company_id).uniq
		@symbols   = Company.where(:id => @companies).map(&:symbol).collect { |symbol| "#{symbol}.PA" }

		data = YahooFinance::get_standard_quotes(@symbols)

		# data methods =========================================
		#  - symbol
		#  - name
		#  - lastTrade: current value
		#  - open: value on day opening
		#  - dayLow: lowest value of the day
		#  - dayHigh: highest value of the day
		#  - date
		#  - time
		#  - change: day highest & lowest variation
		#  - changePercent: day variation
		#  - volume: number of titles traded
		#  - format_html: all data stringified
		#  - bid
		#  - ask

		@symbols.each do |symbol|
			quote      = data[symbol]
			created_at = Time.now(); # TODO: create the WS date
			Quote.create({
				:company_id => Company.find_by_symbol(symbol.split('.').first).id,
				:value      => quote.lastTrade(),
				:created_at => created_at
			})
		end
	end

	def symbols
	    @symbols
	end

	def quotes
		@quotes
	end

end