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

end
