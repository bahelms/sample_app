# Defines db:populate
namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    99.times do |n|
      name = Faker::Name.name
      email = "example--#{n}@hellokitty.org"
      password = "password"
      User.create!(name: name,
                   email: email, 
                   password: password,
                   password_confirmation: password)
    end
  end

  desc "Create just an admin user"
  task admin: :environment do
    User.create!(name: "Jimbonk",
                 email: "jimbonk@jimbonk.org",
                 password: "foobar",
                 password_confirmation: "foobar",
                 admin: true)
  end
end