class Room < ApplicationRecord
    has_one_attached :image
    belongs_to :user
    has_many :reservations, dependent: :destroy # roomが削除されたらreservationsも削除される

    validates :name, presence: true
    validates :introduction, presence: true
    validates :fee, presence: true, numericality: {greater_than_or_equal_to: 1} 
    validates :address, presence: true
end
