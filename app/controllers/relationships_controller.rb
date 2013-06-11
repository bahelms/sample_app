class RelationshipsController < ApplicationController
  before_action :signed_in_user
  respond_to :html

  def create
    @other_user = User.find(params[:relationship][:followed_id])
    current_user.follow!(@other_user)
    respond_with @other_user
  end

  def destroy
    @other_user = Relationship.find(params[:id]).followed
    current_user.unfollow!(@other_user)
    respond_with @other_user
  end
end