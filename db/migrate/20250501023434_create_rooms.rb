class CreateRooms < ActiveRecord::Migration[6.1]
  def change
    create_table :rooms do |t|
      t.string :image
      t.string :name
      t.string :introduction
      t.integer :fee

      t.timestamps
    end
  end
end
