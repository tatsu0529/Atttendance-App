module AttendancesHelper
  
  def attendance_state(attendance)
    
    if Date.current == attendance.worked_on
      return '出勤' if attendance.started_at.nil?
      return '退勤' if attendance.started_at.present? && attendance.finished_at.nil?
    end
    false
  end
  
  def working_times(start, finish)
    format("%.2f", (((finish - start) / 60) / 60.0))
  end
  
  def over_working_times(designed_work_finish_time, finish_time)
    format("%.2f", (((finish_time - designed_work_finish_time) / 60) / 60.0))
  end 
end
