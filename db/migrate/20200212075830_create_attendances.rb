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
      t.string :mark_of_instructor
      t.datetime :overtime_hours
      t.string :change
      t.string :mark_by_instructor
      t.string :request_one_month
      

      t.timestamps
    end
  end
end
