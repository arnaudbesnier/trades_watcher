class Portfolio

	def initialize
		@companies = Trade.opened.map(&:company_id).uniq
		@symbols   = Company.where(:id => @companies).map(&:symbol).collect { |symbol| "#{symbol}.PA" }
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