class CreateWorkouts < ActiveRecord::Migration
  def change
    create_table :workouts do |t|

      t.belongs_to :user, index: true, foreign_key: true

      t.datetime :date
      t.decimal :distance
      t.string :effort
      t.text :note

      t.timestamps null: false
    end
  end
end
