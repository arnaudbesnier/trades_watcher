# encoding: utf-8

module ApplicationHelper

  def format_datetime(datetime)
    return nil unless datetime
    datetime.strftime("%Y %B %d - %H:%M")
  end

  def format_price(value)
    return nil unless value
    "€ #{('%.2f' % value).to_s}"
  end

end
