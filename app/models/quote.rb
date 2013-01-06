class Quote

	def initialize(quote)
		@quote = quote
	end

	# Presentation methods ===================================

	def symbol
		@quote.send('symbol')
	end

	def name
		@quote.send('name')
	end

	def value
		@quote.send('lastTrade')
	end

	def date
		@quote.send('date')
	end

	def time
		@quote.send('time')
	end

	def format_html
		@quote.to_s.html_safe
	end
end