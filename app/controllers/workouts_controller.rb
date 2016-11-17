class WorkoutsController < ApplicationController

  def index
    @workouts = current_user.workouts
    @rolling_total = current_user.rolling_7_day_mileage
    @last_week_total = current_user.last_weeks_mileage
  end

  def new
    @workout = current_user.workouts.build
  end

  def edit
    @workout = current_user.workouts.find(params[:id])
  end

  def create
    @workout = current_user.workouts.build(workout_params)

    if @workout.save
      redirect_to workouts_path(current_user)
    else
      render 'new'
    end

  end

  def update
    @workout = current_user.workouts.find(params[:id])

    if @workout.update(workout_params)
      redirect_to workouts_path(current_user)
    else
      render 'edit'
    end

  end

  private

  def workout_params
    params.require(:workout).permit(:date,:distance,:effort,:note)
  end

end
