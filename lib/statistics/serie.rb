module Statistics
  class Serie

    def initialize values
      @values = values
    end

    # Ecart type
    def deviation decimals=2
      Math.sqrt(variance)
    end

  private

    def sum
      @values.inject { |sum, i| sum + i }
    end

    def mean
      sum / @values.length.to_f
    end

    # Variance
    def variance
      m   = mean
      sum = @values.inject(0) { |accum, i| accum + (i - m) ** 2 }
      sum / @values.length.to_f
    end

  end
end