class RelationshipsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]

  def create
    @user = User.find(params[:followed_id])
    current_user.follow(@user)
    redirect_to_user @user
  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow(@user)
    redirect_to_user @user
  end

  private
    def redirect_to_user(user)
      respond_to do |format|
        format.html { redirect_to user }
        format.js
      end
    end
end
