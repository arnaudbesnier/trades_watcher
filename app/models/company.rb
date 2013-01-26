# == Schema Information
#
# Table name: companies
#
#  id        :integer          not null, primary key
#  name      :string(255)
#  symbol    :string(255)
#  sector_id :integer
#

class Company < ActiveRecord::Base

  attr_accessible :name, :symbol, :sector_id

  validates :name,   :uniqueness => true
  validates :symbol, :uniqueness => true

  belongs_to :sector

  has_many :quotes
  has_many :trades

end
