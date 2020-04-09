class Attendance < ApplicationRecord
  belongs_to :user
  
  validates :worked_on, presence: true
  validates :note, length: { maximum: 50 }
  validates :mark_of_instructor, presence: true
  
  validate :finished_at_is_invalid_without_a_strated_at
  
  validate :finish_time_is_invalid_without_a_started_at
  
  def finished_at_is_invalid_without_a_strated_at
    errors.add(:started_at, "が必要です。") if started_at.blank? && finished_at.present?
  end
  
  def finish_time_is_invalid_without_a_started_at
    errors.add(:started_at, "が必要でdす。")if started_at.blank? && finish_time.present?
  end 
  
end
