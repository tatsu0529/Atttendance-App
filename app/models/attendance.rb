class Attendance < ApplicationRecord
  belongs_to :user
    
  validates :worked_on, presence: true
  validates :note, length: { maximum: 50 }
  
  validate :latest_finished_at_is_invalid_without_a_latest_strated_at
  validate :latest_started_at_is_invalid_without_a_latest_finished_at
  
  validate :latest_started_at_than_latest_finished_at_fast_if_invalid
  
  validate :change_is_needed_when_you_approve_change
  validate :change_is_needed_when_you_approve_overtime
  validate :change_is_needed_when_you_approve_attendance
  
  def latest_started_at_is_invalid_without_a_latest_finished_at
    errors.add(:latest_finished_at, "が必要です。") if latest_finished_at.blank? && latest_started_at.present?
  end
  
  def latest_finished_at_is_invalid_without_a_latest_strated_at
    errors.add(:latest_started_at,"が必要です。") if latest_started_at.blank? && latest_finished_at.present?
  end 
  
  def latest_started_at_than_latest_finished_at_fast_if_invalid
    if latest_started_at.present? && latest_finished_at.present?
      errors.add(:latest_started_at, "より早い退勤時間は無効です") if latest_started_at > latest_finished_at
    end
  end
  
  def change_is_needed_when_you_approve_change
    errors.add(:change,"のチェックがないものは更新されません") if change =="0" && approve_change.present?
  end 
  
  def change_is_needed_when_you_approve_overtime
    errors.add(:change,"のチェックがないものは更新されません") if change == "0" && mark_by_instructor.present?
  end 
  
  def change_is_needed_when_you_approve_attendance
    errors.add(:change,"のチェックがないものは更新されません") if change == "0" && approval_by_boss.present?
  end 
  
end
