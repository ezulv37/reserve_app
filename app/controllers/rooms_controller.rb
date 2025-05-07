class RoomsController < ApplicationController
  def index
    @rooms = Room.all

    if params[:address].present? # 住所が入力されたら検索する
      # Roomモデルからaddressカラムを対象に、params[:address]（検索キーワード）が含まれているレコードを探して@roomsに入れる
      @rooms = @rooms.where("address LIKE ?", "%#{params[:address]}%")
    end

    if params[:keyword].present?
      keyword = "%#{params[:keyword]}%"
      @rooms = @rooms.where("name LIKE ? OR introduction LIKE ?", keyword, keyword)
    end
  end

  def new
    @room = current_user.rooms.new
  end

  def create
    @room = current_user.rooms.new(params.require(:room).permit(:name, :introduction, :fee, :address, :image))
    if @room.save
      flash[:notice] = "施設を新規登録しました"
      redirect_to room_own_path
    else
      render "new"
    end
  end

  def show
    @room = Room.find(params[:id])
    @reservation = @room.reservations.new
  end

  def edit
    @room = current_user.rooms.find(params[:id])
  end

  def update
    @room = current_user.rooms.find(params[:id])


    if @room.update(params.require(:room).permit(:name, :introduction, :fee, :address, :image))
      flash[:notice] = "施設情報を更新しました"
      redirect_to room_own_path
    else
      render "edit"
    end
  end

  def destroy
    @room = Room.find(params[:id])
    @room.destroy
    flash[:notice] = "施設情報を削除しました"
    redirect_to room_own_path
  end
end
