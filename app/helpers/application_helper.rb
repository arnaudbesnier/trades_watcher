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
  	return align_right ' - % ' unless value

    displayed_value = "%.2f" % value
    info            = "0%"

    if value > 0
      info  = "&nbsp;+&nbsp;#{displayed_value}%&nbsp;".html_safe
      style = variation_positive_style
  	elsif value < 0
      info  = "&nbsp;-&nbsp;#{displayed_value.to_s[1..-1]}%&nbsp;".html_safe
      style = variation_negative_style
    end

    align_right(info, style)
  end

  def format_integer(value)
  	return '-' unless value
  	value = value.to_s.reverse.gsub(/...(?=.)/,'\& ').reverse
  	return align_right value
  end

private

  def align_right(content, style='')
  	span :style => "float: right;#{style}" do
  		content
  	end
  end

  def variation_positive_style
    "color: white; font-weight: bold; background-color: #{positive_color};"
  end

  def variation_negative_style
    "color: white; font-weight: bold; background-color: #{negative_color};"
  end

  def positive_color
    '#41A317'
  end

  def negative_color
    '#C11B17'
  end

end
