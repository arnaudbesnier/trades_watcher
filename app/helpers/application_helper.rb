# encoding: utf-8

module ApplicationHelper

  def format_datetime(datetime)
    return nil unless datetime
    datetime.strftime("%Y %b %d - %H:%M")
  end

  # TODO: use option={} parameter
  def format_price(value, decimal=2)
    return nil unless value
    return align_right '€ - ' if value == 0
    formater = "%.#{decimal}f"
    align_right "€ #{(formater % value).to_s}"
  end

  # TODO: use option={} parameter
  def format_variation_price(value, decimal=2, highlight=true)
    return align_right ' € - ' unless value

    displayed_value = "%.#{decimal}f" % value
    info            = '0'

    if value > 0
      info  = "&nbsp;€&nbsp;#{displayed_value}&nbsp;".html_safe
      style = positive_style
    elsif value < 0
      info  = "&nbsp;€&nbsp;#{displayed_value.to_s[1..-1]}&nbsp;".html_safe
      style = negative_style
    end

    style += shadow_style unless highlight

    align_right(info, style)
  end

  # TODO: use option={} parameter
  def format_variation(value, highlight=true)
  	return align_right ' - % ' unless value

    displayed_value = '%.2f' % value
    info            = '0%'

    if value > 0
      info  = "&nbsp;+&nbsp;#{displayed_value}%&nbsp;".html_safe
      style = positive_style
  	elsif value < 0
      info  = "&nbsp;-&nbsp;#{displayed_value.to_s[1..-1]}%&nbsp;".html_safe
      style = negative_style
    end

    style += shadow_style unless highlight

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

  def positive_color
    '#41A317'
  end

  def negative_color
    '#C11B17'
  end

  def positive_style
    "color: white; font-weight: bold; background-color: #{positive_color};"
  end

  def negative_style
    "color: white; font-weight: bold; background-color: #{negative_color};"
  end

  def shadow_style
    'opacity: 0.3;'
  end

end
