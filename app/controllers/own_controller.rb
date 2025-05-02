class OwnController < ApplicationController
  # ログイン済ユーザーのみにアクセスを許可する
  before_action :authenticate_user!

  def show
    @rooms = Room.all
  end
end