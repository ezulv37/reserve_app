class AddNumberOfDateToReservations < ActiveRecord::Migration[6.1]
  def change
    add_column :reservations, :number_of_date, :integer
  end
end
