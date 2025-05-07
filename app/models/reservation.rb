class Reservation < ApplicationRecord
    belongs_to :user
    belongs_to :room

    validates :checkin_date, presence: true
    validates :checkout_date, presence: true
    validates :number_of_guests, presence: true, numericality: {greater_than_or_equal_to: 1}

    validate :start_end_check

    def start_end_check
        return if checkin_date.blank? || checkout_date.blank?

      if checkin_date > checkout_date
           errors.add(:checkout_date,"はチェックイン日より前の日付は設定できません")
      end
    end
end
