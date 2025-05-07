class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true
  validates :email, presence: true
  

  
  
  
  has_one_attached :image

  has_many :rooms, dependent: :destroy  # ユーザーが削除されたらroomsも削除される
  has_many :reservations, dependent: :destroy # ユーザーが削除されたらreservationsも削除される
end
