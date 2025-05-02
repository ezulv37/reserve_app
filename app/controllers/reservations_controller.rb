class ReservationsController < ApplicationController
  def index
    @rooms = Room.includes(:reservations).all
  end

  def new
    @room = Room.find(params[:room_id])
    @reservation = @room.reservations.new # @room にひもづいた 新しい予約オブジェクト（Reservation）を作る
  end

  def confirm
    @room = Room.find(params[:room_id])
    @reservation = @room.reservations.new(params.require(:reservation).permit(:checkin_date, :checkout_date, :number_of_guests))
    if @reservation.valid? # 入力項目に空のものがあれば入力画面に遷移
      # 日数を計算（最低1泊）
      @nights = (@reservation.checkout_date - @reservation.checkin_date).to_i
      @nights = 1 if @nights < 1 # 0泊防止

      # 合計金額を計算（宿泊料金 × 泊数 × 人数）
      @reservation.total_fee = @room.fee * @nights * @reservation.number_of_guests
    else  
      render "rooms/show"
    end
  end

  def create
    @room = Room.find(params[:room_id])
    @reservation = @room.reservations.new(params.require(:reservation).permit(:checkin_date, :checkout_date, :number_of_guests))
    
    nights = (@reservation.checkout_date - @reservation.checkin_date).to_i
    nights = 1 if nights < 1
    @reservation.total_fee = @room.fee * nights

    if @reservation.save
      redirect_to reservations_index_path, notice:"予約が完了しました"
    else
      render :confirm
    end
  end

  def edit
    @room = Room.find(params[:room_id])
    @reservation = Reservation.find(params[:id])
  end

  def update
    @room = Room.find(params[:room_id])
    @reservation = Reservation.find(params[:id])
    if @reservation.update(params.require(:reservation).permit(:checkin_date, :checkout_date, :total_fee, :number_of_guests))
      flash[:notice] = "施設情報を更新しました"
      redirect_to reservations_index_path
    else
      render "edit"
    end
  end

  def destroy
    @reservation = Reservation.find(params[:id])
    @reservation.destroy
    flash[:notice] = "予約を削除しました"
    redirect_to reservations_index_path
  end
end