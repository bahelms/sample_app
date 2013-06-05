# This file is loaded automatically by RSpec
FactoryGirl.define do
  factory :user do      # :user says this is for the User model
    sequence(:name)  { |n| "Person_#{n}" }
    sequence(:email) { |n| "person_#{n}@heyhe.com" }
    password "123456"
    password_confirmation "123456"

    factory :admin do
      admin true
    end
  end

  factory :micropost do
    content "Lorem ipsum"
    user
  end
end