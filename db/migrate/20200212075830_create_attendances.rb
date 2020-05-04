class CreateAttendances < ActiveRecord::Migration[5.1]
  def change
    create_table :attendances do |t|
      t.date :worked_on
      t.datetime :started_at
      t.datetime :finished_at
      t.string :note
      t.references :user, foreign_key: true
      t.datetime :finish_time
      t.string :work_contents
      t.string :overtime_status
      t.datetime :overtime_hours
      t.string :change
      t.string :one_month_status
      t.string :change_status
      t.datetime :latest_started_at
      t.datetime :latest_finished_at
      t.datetime :start_on
      t.datetime :end_on
      t.string :tomorrow
      t.string :instructor_mark
      t.timestamps
    end
  end
end
