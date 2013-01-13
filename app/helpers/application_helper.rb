# encoding: utf-8

module ApplicationHelper

  def format_datetime(datetime)
    return nil unless datetime
    datetime.strftime("%Y %B %d - %H:%M")
  end

  def format_price(value, decimal=2)
    return nil unless value
    return align_right "€ - " if value == 0
    formater = "%.#{decimal}f"
    align_right "€ #{(formater % value).to_s}"
  end

  def format_variation(value)
  	return align_right '- %' unless value
	displayed_value = "%.2f" % value
  	return align_right "+ #{displayed_value}%" if value > 0
  	return align_right "- #{displayed_value.to_s[1..-1]}%" if value < 0
  	align_right "#{displayed_value}%"
  end

  def format_integer(value)
  	return '-' unless value
  	value = value.to_s.reverse.gsub(/...(?=.)/,'\& ').reverse
  	return align_right value
  end

private

  def align_right(content)
  	span :style => 'float: right;' do
  		content
  	end
  end

end
