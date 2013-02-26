# encoding: utf-8

module ApplicationHelper

  def format_decimal value
    align_right "&nbsp;#{value.blank? ? ' - ' : ('%.2f' % value)}&nbsp;".html_safe
  end

  def format_percent(value, options={})
    return nil if value.blank?

    right_align = options[:right_align].nil? ? true : options[:right_align]
    shadow      = options[:shadow].nil? ? false : options[:shadow]

    wrapper     = right_align ? 'align_right' : 'align_left'
    send(wrapper, "&nbsp;#{'%.2f %' % (value * 100)}&nbsp;".html_safe, shadow ? "opacity: #{Math.sqrt(value)*value*20};" : nil)
  end

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

  def format_price_display(value)
    '€ %.2f' % value
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

  def format_price_with_sign(value, options={})
    return nil unless value

    right_align = options[:right_align].nil? ? true : options[:right_align]
    wrapper     = right_align ? 'align_right' : 'align_left'

    return send(wrapper, '€ - ') if value == 0

    displayed_value = '%.2f' % value

    if value > 0
      info  = "€&nbsp;+#{displayed_value}".html_safe
      style = positive_style
    elsif value < 0
      info  = "€&nbsp;#{displayed_value}".html_safe
      style = negative_style
    end

    send(wrapper, info, style)
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
      info  = "€&nbsp;#{displayed_value}".html_safe
      style = positive_style
    elsif value < 0
      info  = "€&nbsp;#{displayed_value.to_s[1..-1]}".html_safe
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
      info  = "+&nbsp;#{displayed_value}%".html_safe
      style = positive_style
  	elsif value < 0
      info  = "-&nbsp;#{displayed_value.to_s[1..-1]}%".html_safe
      style = negative_style
    end

    style += shadow_style unless highlight

    send(wrapper, info, style)
  end

  def format_price_and_variation(price, variation, options={})
    right_align = options[:right_align].nil? ? true : options[:right_align]
    wrapper     = right_align ? 'align_right' : 'align_left'

    return send(wrapper, ' € -  ( - %)') unless price && variation && 

    displayed_price     = "%.2f" % price
    displayed_variation = "%.2f" % variation
    info                = '€&nbsp;0.00&nbsp;(0.00%)'.html_safe

    if variation > 0
      info  = "€&nbsp;#{displayed_price}&nbsp;(+#{displayed_variation}%)".html_safe
      style = positive_style
    elsif variation < 0
      info  = "€&nbsp;#{displayed_price.to_s[1..-1]}&nbsp;(#{displayed_variation}%)".html_safe
      style = negative_style
    end

    send(wrapper, info, style)
  end

  def format_integer(value, options={})
    right_align = options[:right_align].nil? ? true : options[:right_align]
    wrapper     = right_align ? 'align_right' : 'align_left'

  	return send(wrapper, '-') unless value && value != 0

  	value = value.to_s.reverse.gsub(/...(?=.)/,'\& ').reverse
  	return send(wrapper, value)
  end

  def show_link_icon object
    span link_to(tag(:img, :src => asset_path('admin/show.png'), :height => 15, :title => 'Show'),
                      send("admin_#{object.class.name.downcase}_path", object))
  end

  def edit_link_icon object
    span link_to(tag(:img, :src => asset_path('admin/edit.png'), :height => 15, :title => 'Edit'),
                      send("edit_admin_#{object.class.name.downcase}_path", object))
  end

  def web_link_icon icon, url
    link_to(tag(:img, :src => asset_path("admin/#{icon}"), :height => 15), url, { :target => '_blanc' })   
  end

  def candlechart_options
    {
      :width           => '100%',
      :height          => 240,
      :legend          => 'none',
      :colors          => ['#6698FF'],
      :backgroundColor => { :strokeWidth => 2 },
      :candlestick     => {
        :risingColor  => { :fill => '#FFFFFF', :stroke => '#6698FF' },
        :fallingColor => { :fill => '#6698FF', :stroke => '#6698FF' }
      }
    }
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

  def positive_style
    "color: #41A317; text-shadow: 1px 1px 0px #AAFF77;"
  end

  def negative_style
    "color: #C11B17; text-shadow: 1px 1px 0px #FF9999;"
  end

  def shadow_style
    'opacity: 0.3;'
  end

end
