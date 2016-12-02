class WorkoutsController < ApplicationController

  def index
    @workouts = current_user.workouts
    @rolling_total = current_user.rolling_7_day_mileage
    #@last_week_total = current_user.last_weeks_mileage
    @last_week_total = current_user.get_previous_week_mileage(weeks_ago: 1)

    # final plan would be do an ajax get for the run suggestion so we're doing doing the setup calculations if we need to
    # and display it in some sort of pop up dialog
    @suggested_run = training_suggestion
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

  # some kind of modal jquery pop up maybe ?
  def training_suggestion
    TrainingPartner.new(user: current_user).suggest_run
  end

  def mileage_chart
    render json: current_user.workouts.group_by_week(:date).sum(:distance)
  end

  private

  def workout_params
    params.require(:workout).permit(:date,:distance,:effort,:note)
  end

end
