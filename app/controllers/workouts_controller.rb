class WorkoutsController < ApplicationController

  def new
    @workout = current_user.workouts.build
  end

  def index
    @workouts = current_user.workouts
    @rolling_total = current_user.rolling_7_day_mileage
    @last_week_total = current_user.last_weeks_mileage
  end

  def create

    @workout = current_user.workouts.build(workout_params)

    if @workout.save
      redirect_to workouts_path(current_user)
    else
      render 'new'
    end

  end

  private

  def workout_params
    params.require(:workout).permit(:date,:distance,:effort,:note)
  end

end
