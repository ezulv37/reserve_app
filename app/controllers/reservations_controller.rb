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

    if params[:id].present?
      # 再予約(更新)の場合
      @reservation = @room.reservations.find(params[:id])
      @reservation.assign_attributes(params.require(:reservation).permit(:checkin_date, :checkout_date, :number_of_guests, :number_of_date, :total_fee))
    else
      # 新規予約の場合
      @reservation = @room.reservations.new(params.require(:reservation).permit(:checkin_date, :checkout_date, :number_of_guests, :number_of_date, :total_fee))
    end
    
    # 共通の処理(宿泊料金を計算)
    if @reservation.valid? # 入力項目に空のものがあれば入力画面に遷移
      # 日数を計算（最低1泊）
      @nights = (@reservation.checkout_date - @reservation.checkin_date).to_i
      
      # 0泊防止
      @nights = 1 if @nights < 1

      # 合計金額を計算（宿泊料金 × 泊数 × 人数）
      @reservation.total_fee = @room.fee * @nights * @reservation.number_of_guests
    else  
      render params[:id].present? ? "edit" : "rooms/show"
    end
  end

  def create
    @room = Room.find(params[:room_id])
    @reservation = @room.reservations.new(params.require(:reservation).permit(:checkin_date, :checkout_date, :number_of_guests, :number_of_date, :total_fee))
    
    # 宿泊料金を計算
    @nights = (@reservation.checkout_date - @reservation.checkin_date).to_i
    @nights = 1 if @nights < 1
    @reservation.total_fee = @room.fee * @nights * @reservation.number_of_guests

    if @reservation.save
      redirect_to reservations_index_path, notice:"予約が完了しました"
    else
      render :confirm
    end
  end

  def edit
    @room = Room.find(params[:room_id])
    @reservation = @room.reservations.find(params[:id])
  end

  def update
    @room = Room.find(params[:room_id])
    @reservation = @room.reservations.find(params[:id])
    
    # 宿泊料金を計算
    @nights = (@reservation.checkout_date - @reservation.checkin_date).to_i
    @nights = 1 if @nights < 1
    @reservation.total_fee = @room.fee * @nights * @reservation.number_of_guests
    
    if @reservation.update(params.require(:reservation).permit(:id, :checkin_date, :checkout_date, :number_of_guests, :number_of_date, :total_fee))
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