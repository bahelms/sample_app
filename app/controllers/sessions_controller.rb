class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:Email].downcase)  # params[:session][:email] with form_for
    if user && user.authenticate(params[:Password])
      sign_in user
      redirect_back_or user
    else
      flash.now[:error] = "Invalid email/password combination"  # Flash for current request
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_url
  end
end
