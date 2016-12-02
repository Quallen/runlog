class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :workouts

  def rolling_7_day_mileage
    self.workouts.where(:date => 7.days.ago.beginning_of_day..DateTime.now.end_of_day ).sum(:distance)
  end

  # def last_weeks_mileage
  #   self.workouts.where(:date => 1.week.ago.beginning_of_week..1.week.ago.end_of_week).sum(:distance)
  # end

  def get_previous_week_mileage(weeks_ago: )
    self.workouts.where(:date => weeks_ago.week.ago.beginning_of_week..weeks_ago.week.ago.end_of_week).sum(:distance)
  end

end
