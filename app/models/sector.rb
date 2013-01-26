# == Schema Information
#
# Table name: sectors
#
#  id   :integer          not null, primary key
#  name :string(255)
#

class Sector < ActiveRecord::Base

  attr_accessible :name

  validates :name,   :uniqueness => true

  has_many :companies

end
