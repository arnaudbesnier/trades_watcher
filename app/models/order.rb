# == Schema Information
#
# Table name: orders
#
#  id         :integer          not null, primary key
#  company_id :integer
#  shares     :integer
#  price      :decimal(, )
#  order_type :integer
#  commission :decimal(, )
#  taxes      :decimal(, )
#  created_at :datetime
#

class Order < ActiveRecord::Base

  attr_accessible :company_id, :shares, :price, :order_type,
                  :commission, :taxes, :created_at

end
