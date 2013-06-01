# This is a helper file for RSpec
include ApplicationHelper

def valid_signin(user)
  fill_in "Email",    with: user.email
  fill_in "Password", with: user.password
  click_button "Sign In"
end
  
RSpec::Matchers.define :have_error_message do |message|
  match do |page|
    expect(page).to have_selector('div.alert.alert-error', text: message)
  end
end
  
RSpec::Matchers.define :have_success_message do |message|
  match do |page|
    expect(page).to have_selector('div.alert.alert-success', text: message)
  end
end

def valid_signup
  fill_in "Name",             with: "Motherfucker Jones"
  fill_in "Email",            with: "foo@bar.com"
  fill_in "Password",         with: "123456"
  fill_in "Confirm Password", with: "123456"
end

def sign_in(user)
  visit signin_path
  valid_signin user
  cookies[:remember_token] = user.remember_token
end