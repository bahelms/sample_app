require 'spec_helper'

describe "Authentication" do
  let(:user) { FactoryGirl.create(:user) }
  subject { page }

  describe "signin page" do
    before { visit signin_path }

    it { should have_title('Sign In') }
    it { should have_content('Sign In') }

    describe "with invalid information" do
      before { click_button "Sign In" }

      it { should have_error_message('Invalid') }
      it { should_not have_link('Profile',  href: user_path(user)) }
      it { should_not have_link('Settings', href: edit_user_path(user)) }

      describe "after visiting another page" do
        before { click_link 'Home' }
        it { should_not have_error_message('Invalid') }
      end
    end

    describe "with valid information" do
      before { sign_in(user) }

      it { should have_title(user.name) }
      it { should have_link('Profile',     href: user_path(user)) }
      it { should have_link('Users',       href: users_path) }
      it { should have_link('Settings',    href: edit_user_path(user)) }
      it { should have_link('Sign Out',    href: signout_path) }
      it { should_not have_link('Sign In', href: signin_path) }

      describe "followed by signout" do
        before { click_link "Sign Out" }
        it { should have_link("Sign In") }
      end
    end
  end

  describe "authorization" do
    
    describe "for signed-out users" do

      context "in the Users controller" do
        describe "visiting the edit page" do
          before { visit edit_user_path(user) }
          it { should have_title('Sign In') }
        end

        describe "submitting to the update action" do
          before { patch user_path(user) }
          specify { expect(response).to redirect_to(signin_path)}
        end

        describe "visiting the user index" do
          before { visit users_path }
          it { should have_title('Sign In') }
        end
      end

      describe "when attempting to visit a protected page" do
        before do
          visit edit_user_path(user)
          sign_in user
        end

        describe "after signing in" do
          it "should render the desired protected page" do
            expect(page).to have_title("Edit User")
          end

          describe "after signing in again" do
            before do
              delete signout_path
              visit signin_path
              sign_in user
            end

            it "should render the user's prog" do
              expect(page).to have_title(user.name)
            end
          end
        end
      end

      describe "in the Microposts controller" do
        
        describe "submitting to the create action" do
          before { post microposts_path }
          specify { expect(response).to redirect_to(signin_path) }
        end

        describe "submitting to the destroy action" do
          before { delete micropost_path(FactoryGirl.create(:micropost)) }
          specify { expect(response).to redirect_to(signin_path) }
        end
      end
    end

    describe "as wrong user" do
      let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
      before { sign_in user }

      describe "visiting Users#edit" do
        before { visit edit_user_path(wrong_user) }
        it { should_not have_title(full_title('Edit User')) }
      end

      describe "submitting a PATCH request to Users#update action" do
        before { patch user_path(wrong_user) }
        specify { expect(response).to redirect_to(root_path) }
      end
    end

    describe "as non-admin user" do
      let(:non_admin) { FactoryGirl.create(:user) }
      before { sign_in non_admin }

      describe "sending a delete request to Users#destroy" do
        before { delete user_path(user) }
        specify { expect(response).to redirect_to(root_path) }
      end
    end
  end
end