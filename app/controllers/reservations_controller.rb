class ReservationsController < ApplicationController
  def index
    @reservations = current_user.reservations
    @rooms = @reservations.map(&:room).uniq
  end

  def new
    @room = Room.find(params[:room_id])
    @reservation = @room.reservations.new # @room にひもづいた 新しい予約オブジェクト（Reservation）を作る
  end

  def confirm
    @room = Room.find(params[:room_id])
    @reservation = @room.reservations.new(params.require(:reservation).permit(:checkin_date, :checkout_date, :number_of_guests, :number_of_date, :total_fee))
    @reservation.user = current_user
    
    # 共通の処理(宿泊料金を計算)
    if @reservation.valid? # 入力項目に空のものがあれば入力画面に遷移
      
      # 日数を計算（最低1泊）
      @nights = (@reservation.checkout_date - @reservation.checkin_date).to_i
      
      # 0泊防止
      @nights = 1 if @nights < 1

      # 合計金額を計算（宿泊料金 × 泊数 × 人数）
      @reservation.total_fee = @room.fee * @nights * @reservation.number_of_guests
      @reservation.number_of_date = @nights

      render :confirm
    else  
      render "rooms/show"
    end
  end

  def create
    @room = Room.find(params[:room_id])
    @reservation = @room.reservations.new(params.require(:reservation).permit(:checkin_date, :checkout_date, :number_of_guests, :number_of_date, :total_fee))
    @reservation.user = current_user

    # 宿泊料金を計算
    @nights = (@reservation.checkout_date - @reservation.checkin_date).to_i
    @nights = 1 if @nights < 1
    @reservation.total_fee = @room.fee * @nights * @reservation.number_of_guests
    @reservation.number_of_date = @nights


    if @reservation.save
      redirect_to reservations_index_path, notice:"予約が完了しました"
    else
      render :confirm
    end
  end

  def destroy
    @reservation = Reservation.find(params[:id])
    @reservation.destroy
    flash[:notice] = "予約を削除しました"
    redirect_to reservations_index_path
  end
end