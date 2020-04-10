require 'csv'

CSV.generate do |csv|
  column_names = %w(日付 出勤 退勤)
  csv << csv_column_names
  @attendancs.each do |attendance|
    column_values = [
      attendance.worked_on.to_s(:date),
      if attendance.started_at.prensent?
        attendance.started_at.strftime("%R")
      end, 
      if attendance.finished_at.prensent?
        attendance.finished_at.strftime("%R")
      end,
    ]
    csv << column_values
  end
end
NKF::nkf('--sjis -Lw', csv_str)