class Portfolio

  def initialize
    @symbols = Company.all.map(&:symbol).collect { |symbol| "#{symbol}.PA" }

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
      quote = data[symbol]

      date_elements = quote.date().split('/')
      year          = date_elements.last
      month         = date_elements.first
      day           = date_elements[1]
      time_elements = quote.time().split(':')
      hour          = time_elements.first.to_i + 6 # +6 for Paris
      minute        = time_elements.last[0..1]
      created_at    = Time.new(year, month, day, hour, minute)

      last_day_value     = quote.lastTrade() * (1 - quote.changePercent() / 100)
      variation_day_low  = (quote.dayLow() - last_day_value) / last_day_value * 100
      variation_day_high = (quote.dayHigh() - last_day_value) / last_day_value * 100

      Quote.create({
        :company_id            => Company.find_by_symbol(symbol.split('.').first).id,
        :value                 => quote.lastTrade(),
        :volume                => quote.volume(),
        :value_day_open        => quote.open(),
        :value_day_low         => quote.dayLow(),
        :value_day_high        => quote.dayHigh(),
        :variation_day_current => quote.changePercent(),
        :variation_day_low     => variation_day_low,
        :variation_day_high    => variation_day_high,
        :created_at            => created_at
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