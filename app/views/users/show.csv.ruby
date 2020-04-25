require 'csv'

CSV.generate do |csv|
  column_names = %w(出勤日 出社時間 変更後出社時間 退社時間 変更後退社時間)
  csv << column_names
  @attendances.each do |a|
    column_values = [
      l(a.worked_on, format: :short),
      if a.started_at.present?
        l(a.started_at, format: :feather)
      else
        ""
      end,
      if a.latest_started_at.present?
        l(a.latest_started_at, format: :feather)
      else
        ""
      end,
      if a.finished_at.present?
        l(a.finished_at, format: :feather)
      else
        ""
      end,
      if a.latest_finished_at.present?
        l(a.latest_finished_at, format: :feather)
      else
        ""
      end
    ]
    csv << column_values
  end
end