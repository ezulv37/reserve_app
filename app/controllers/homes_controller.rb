class HomesController < ApplicationController
  def index
    @rooms = Room.all

    if params[:address].present? # 住所が入力されたら検索する
      # Roomモデルからaddressカラムを対象に、params[:address]（検索キーワード）が含まれているレコードを探して@roomsに入れる
      @rooms = Room.where("address LIKE ?", "%#{params[:address]}%")
    end
  end
end
