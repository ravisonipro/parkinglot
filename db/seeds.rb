# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# user = CreateAdminService.new.call
# puts 'CREATED ADMIN USER: ' << user.email

#trial plan
Subscription.create(plan_type: "trial", price: 0.0, cycle: "14 days", features: ["parking_pos"])

#Basic plan
Subscription.create(plan_type: "Basic", price: 5.99, cycle: "monthly", features: ["parking_pos", "Loyalty_program_access", "social_space_sharing"])

#Standard plan
Subscription.create(plan_type: "Standard", price: 7.99, cycle: "monthly", features: ["wayfinding", "parking_pos", "Loyalty_program_access", "social_space_sharing", "lot_attendant_profile", "promotions"])

#Premium plan
Subscription.create(plan_type: "Premium", price: 9.99, cycle: "monthly", features: ["wayfinding", "parking_pos", "Loyalty_program_access", "premium_rewards", "social_space_sharing", "lot_attendant_profile", "promotions", "plb_reminders"])


