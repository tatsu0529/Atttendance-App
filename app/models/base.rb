class Base < ApplicationRecord
  
  validates :name, presence: true
  validates :attendance_sort, presence: true
end
