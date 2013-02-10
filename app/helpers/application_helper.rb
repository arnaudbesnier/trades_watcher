# encoding: utf-8

module ApplicationHelper

  def format_date(date)
    return nil unless date
    date.strftime("%Y %b %d")
  end

  def format_datetime(datetime)
    return nil unless datetime
    datetime.strftime("%Y %b %d - %H:%M")
  end

  def format_status(value, options={})
    return nil unless value

    align_left "&nbsp;#{value.to_s.gsub(/_/, ' ')}&nbsp;".html_safe, "color: #FFFFFF; font-weight: bold; background-color: #{options[:color]};"
  end

  def format_price(value, options={})
    return nil unless value

    decimal     = options[:decimal] || 2
    right_align = options[:right_align].nil? ? true : options[:right_align]
    wrapper     = right_align ? 'align_right' : 'align_left'

    return send(wrapper, '€ - ') if value == 0

    formater = "%.#{decimal}f"
    send(wrapper, "€ #{(formater % value).to_s}")
  end

  def format_variation_price(value, options={})
    decimal     = options[:decimal] || 2
    right_align = options[:right_align].nil? ? true : options[:right_align]
    highlight   = options[:highlight].nil? ? true : options[:highlight]
    wrapper     = right_align ? 'align_right' : 'align_left'

    return send(wrapper, ' € - ') unless value && value != 0

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

    send(wrapper, info, style)
  end

  def format_variation(value, options={})
    right_align = options[:right_align].nil? ? true : options[:right_align]
    highlight   = options[:highlight].nil? ? true : options[:highlight]
    wrapper     = right_align ? 'align_right' : 'align_left'

  	return send(wrapper, ' - % ') unless value

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

    send(wrapper, info, style)
  end

  def format_integer(value, options={})
    right_align = options[:right_align].nil? ? true : options[:right_align]
    wrapper     = right_align ? 'align_right' : 'align_left'

  	return send(wrapper, '-') unless value

  	value = value.to_s.reverse.gsub(/...(?=.)/,'\& ').reverse
  	return send(wrapper, value)
  end

private

  def align_left(content, style='')
    span :style => "#{style}" do
      content
    end
  end

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
