# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

# Admin User ============================================================

#AdminUser.delete_all
#AdminUser.find_or_create_by_id(1) do |user|
# # Run only in case of creation
#  user.email                 = 'arnaudibesnier@gmail.com'
#  user.password              = 'changeme'
#  user.password_confirmation = 'changeme'
#  user.save
#end


# Initial Data ==========================================================

Rake::Task["db:create_companies"].execute
Rake::Task["db:create_transactions"].execute
Rake::Task["db:create_orders"].execute
Rake::Task["db:create_dividends"].execute