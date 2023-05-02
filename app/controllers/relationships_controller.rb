class RelationshipsController < ApplicationController
  before_action :authenticate_user!
  #そのコントローラーのアクションにアクセスする前に、必ずユーザーがログイン済みであることを確認できるもの
  def create
    user = User.find(params[:user_id])
    current_user.follow(user)
		redirect_to request.referer
  end
  
  def destroy
    user = User.find(params[:user_id])
    current_user.unfollow(user)
		redirect_to request.referer
  end
  
  def followings
    user = User.find(params[:user_id])
		@users = user.followings
		# has_many :followings, through: :relationships, source: :followed 
  end

  def followers
    user = User.find(params[:user_id])
		@users = user.followers
  end
end
