# logic for workouts will be calculated here

class TrainingPartner

  # need to get previous 2 weeks mileage
  # also need to get rolling 7 day mileage (sort of)

  # pass in user workouts
  def initialize(user:)

    @workouts = user.workouts.group_by_week(:date).sum(:distance)
    # inputs
    @rolling_total = user.rolling_7_day_mileage
    @last_week_total = user.get_previous_week_mileage(weeks_ago: 1)
    @current_week_total = user.get_previous_week_mileage(weeks_ago: 0)
    # I should account for their being more than one run entered on a given day
    # @yesterday_distance = user.workouts.group(:date).order("date DESC").sum(:distance)&.first[1]
    @last_hard_day = user.workouts.where(:effort => Workout::EFFORT_LIST.last).order("date DESC").take&.date

  end


  def suggest_run
    # Rules
    # - Want to keep rolling mileage under last week total * 1.1
    # - Want to keep week to week increase under 10%
    # - Hard / Workouts should be followed by a recovery day
    # - Need to make sure we have room in current week mileage for the above long run + a short recovery run the following day
    # - Need some formula to calc what a long run should be - Maybe avg total mileage / 4 ?

    # inputs - rolling total - current week total - last week total - yesterdays run

    # Might be a good candidate for a rules engine but for now keep it simple

    # if yesterday was a hard day return an easy 1.5-3 mile run - figure out the scaling based on last week total
    if @last_hard_day == Date.yesterday
      easy_run = @last_week_total / 10
      return "Easy #{ easy_run <= 1.5 ? 1.5 : easy_run } mile run to recover from yesterdays hard effort"
    # if there is room for a long run recommend it
    elsif room_in_rolling_total? && room_in_current_week?
      return "Moderate #{long_run_distance} mile long run"
    else
      return 42
    end

  end

  # should probably get an average total mileage of the last few weeks for better accuracy
  def long_run_distance
    @last_week_total / 4.0
  end

  # determine if there is room for long run in current rolling total mileage
  def room_in_rolling_total?
    (@rolling_total + long_run_distance) < (@last_week_total * 1.1)
  end

  # check daily average vs expected (with margin)
  def room_in_current_week?
    ((@current_week_total / Date.today.cwday) / 0.9 ) < ( (@last_week_total * 1.1) / 7.0)
  end



end
