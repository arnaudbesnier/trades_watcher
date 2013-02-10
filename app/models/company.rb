# == Schema Information
#
# Table name: companies
#
#  id        :integer          not null, primary key
#  name      :string(255)
#  symbol    :string(255)
#  sector_id :integer
#  index     :string(255)
#

class Company < ActiveRecord::Base

  attr_accessible :name, :symbol, :sector_id, :index

  validates :name,   :uniqueness => true
  validates :symbol, :uniqueness => true

  belongs_to :sector

  has_many :quotes
  has_many :trades

  def has_opened_trade?
    Trade.opened.where(:company_id => self).any?
  end

end
