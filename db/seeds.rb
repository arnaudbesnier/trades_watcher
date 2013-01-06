# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

# Admin User ============================================================

AdminUser.find_or_create_by_id(1) do |user|
  # Run only in case of creation
  user.email = 'arnaudibesnier@gmail.com'
  user.password = 'changeme'
  user.password_confirmation = 'changeme'
  user.save
end


# Companies =============================================================

companies = [
	{ :name => 'Gemalto NV',                          :symbol => 'GTO' },
	{ :name => 'EADS NV',                             :symbol => 'EAD' },
	{ :name => 'Groupe Danone SA',                    :symbol => 'BN'  },
	{ :name => 'Dassault Systemes S.A.',              :symbol => 'DSY' },
	{ :name => 'LVMH Moet Hennessy Louis Vuitton SA', :symbol => 'MC'  },
	{ :name => 'Compagnie de Saint Gobain SA',        :symbol => 'SGO' },
	{ :name => 'Air Liquide',                         :symbol => 'AI'  },
	{ :name => 'Pernod Ricard SA',                    :symbol => 'RI'  },
	{ :name => 'Societe Generale SA',                 :symbol => 'GLE' },
	{ :name => 'Total S.A.',                          :symbol => 'FP'  },
	{ :name => 'BNP Paribas SA',                      :symbol => 'BNP' },
	{ :name => "L'Oreal",                             :symbol => 'OR'  },
	{ :name => 'Iliad SA',                            :symbol => 'ILD' },
	{ :name => 'Renault SA',                          :symbol => 'RNO' }
]

companies.each do |company|
	Company.create(company)
end