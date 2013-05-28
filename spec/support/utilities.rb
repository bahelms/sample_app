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

def user_valid_signin
  fill_in "Name",         with: "Motherfucker Jones"
  fill_in "Email",        with: "foo@bar.com"
  fill_in "Password",     with: "123456"
  fill_in "Confirmation", with: "123456"
end