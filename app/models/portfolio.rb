class Portfolio

	def initialize
		@symbols = ['GTO.PA', 'RNO.PA']
		@quotes  = {}

		data = YahooFinance::get_standard_quotes(@symbols)

		@symbols.each do |s|
			@quotes[s] = Quote.new(data[s])
		end
	end

	def symbols
	    @symbols
	end

	def quotes
		@quotes
	end

end