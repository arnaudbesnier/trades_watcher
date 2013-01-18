# == Schema Information
#
# Table name: companies
#
#  id     :integer          not null, primary key
#  name   :string(255)
#  symbol :string(255)
#

class Company < ActiveRecord::Base

  attr_accessible :name, :symbol

  validates :name,   :uniqueness => true
  validates :symbol, :uniqueness => true

  has_many :quotes
  has_many :trades

end
