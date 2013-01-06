class PortfolioController < ApplicationController

	def index
		@quotes = Portfolio.new.quotes
	end

end