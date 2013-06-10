namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_users
    make_microposts
    make_relationships
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

def make_users
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

def make_microposts
  50.times do
    users = User.all(limit: 6)
    content = Faker::Lorem.sentence(5)
    users.each { |user| user.microposts.create!(content: content) }
  end
end

def make_relationships
  users = User.all
  user = users.first
  followed_users = users[2..50]
  followers      = users[3..40]
  followed_users.each { |followed| user.follow!(followed) }
  followers.each { |follower| follower.follow!(user) }
end