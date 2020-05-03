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
  
  validate :about_one_month_status
  validate :about_change_status
  validate :about_overtime_status
  
  validate :finish_time_is_needed_when_you_request_overtime
  
  validate :change_status_is_needed_when_you_request_change
  
  def latest_started_at_is_invalid_without_a_latest_finished_at
    errors.add(:latest_finished_at, "が必要です。") if latest_finished_at.blank? && latest_started_at.present?
  end
  
  def latest_finished_at_is_invalid_without_a_latest_strated_at
    errors.add(:latest_started_at,"が必要です。") if latest_started_at.blank? && latest_finished_at.present?
  end 
  
  def latest_started_at_than_latest_finished_at_fast_if_invalid
    if tomorrow != "1" && latest_started_at.present? && latest_finished_at.present?
      errors.add(:latest_started_at, "より早い退勤時間は無効です") if latest_started_at > latest_finished_at
    elsif tomorrow == "1" && latest_started_at.present? && latest_finished_at.present?
      errors.add(:latest_started_at, "より遅い退勤時間は無効です") if latest_started_at < latest_finished_at
    end
  end
  
  def change_is_needed_when_you_approve_change
    errors.add(:change,"のチェックがないものは更新されません") if change =="0" && change_status.present?
  end 
  
  def change_is_needed_when_you_approve_overtime
    errors.add(:change,"のチェックがないものは更新されません") if change == "0" && overtime_status.present?
  end 
  
  def change_is_needed_when_you_approve_attendance
    errors.add(:change,"のチェックがないものは更新されません") if change == "0" && one_month_status.present?
  end 
  
  def about_one_month_status
    errors.add(:one_month_status,"は承認か否認を選択してください") if one_month_status == "なし" || one_month_status == "申請中"
  end 
  
  def about_change_status
    errors.add(:change_status,"は承認か否認を選択してください") if change_status == "申請中"
  end 
  
  def about_overtime_status
    errors.add(:ovetime_status,"は承認か否認を選択してください") if overtime_status == "申請中"
  end 
  
  def finish_time_is_needed_when_you_request_overtime
    if overtime_status.present?
      errors.add(:finish_time, "を選択してください") if finish_time.blank?
    end 
  end
  
  def change_status_is_needed_when_you_request_change
    if latest_started_at.present?
      errors.add(:change_status, "を選択してください") if change_status.blank?
    end 
  end 
end
