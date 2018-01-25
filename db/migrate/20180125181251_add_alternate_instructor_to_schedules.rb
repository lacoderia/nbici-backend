class AddAlternateInstructorToSchedules < ActiveRecord::Migration
  def change
    add_column :schedules, :alternate_instructor_id, :integer
  end
end
