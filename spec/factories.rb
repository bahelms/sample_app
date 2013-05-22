# This file is loaded automatically by RSpec
FactoryGirl.define do
  factory :user do      # :user says this is for the User model
    name "Bob Firsty"
    email "bar@baz.com"
    password "123456"
    password_confirmation "123456"
  end
end