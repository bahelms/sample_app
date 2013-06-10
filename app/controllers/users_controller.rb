class UsersController < ApplicationController
  before_action :signed_in_user, only: [:index, :edit, :update, :destroy, 
                                        :followers, :following]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: [:destroy]

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
  	@user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def new
    redirect_to(root_path) if signed_in?
  	@user = User.new
  end

  def create
    redirect_to(root_path) if signed_in?
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)  
      flash[:succes] = "Profile Updated"
      sign_in @user  # remember_token changes on save; must sign in again
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    user = User.find(params[:id])
    unless user.admin?
      user.destroy
      flash[:success] = "User destroyed."
      redirect_to users_url
    end
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.followed_users.paginate(page: params[:page])
    render 'show_follow'
  end

  private
    def user_params
      # Require that :user be a key in the params hash, and only accept the 
      # permit argument attributes. This avoids mass assignment with strong
      # parameters.
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    # Before filters
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
end
