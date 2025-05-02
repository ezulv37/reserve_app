class CreateReservations < ActiveRecord::Migration[6.1]
  def change
    create_table :reservations do |t|
      t.string :image
      t.string :name
      t.string :introduction
      t.integer :total_fee
      t.date :checkin_date
      t.date :checkout_date

      t.timestamps
    end
  end
end
