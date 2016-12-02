require 'spec_helper'

feature 'workout tests - ' do

  before(:each) do
    user = FactoryGirl.build(:user, :email => "test@test.com", :password => "1344Silas!")
    user.save

    visit root_path

    fill_in('Email', :with => "test@test.com")
    fill_in('Password', :with => "1344Silas!")

    click_button 'Log in'
  end

  after(:each) do
  end

  scenario "a user can log a run and it will then show on the index" do

    click_link 'Log New Run'

    fill_in('Date', :with => "#{Date.today}")
    fill_in('Distance', :with => "2.73")
    select("easy / recovery", :from => "Effort")
    fill_in('Note', :with => "Imaginary runs are often easy")

    click_button 'Submit'

    # expect to see the run we just logged
    page.should have_content("2.73")

  end

  scenario "model presence validations" do

    click_link 'Log New Run'

    click_button 'Submit'

    page.should have_content "Date can't be blank"
    page.should have_content "Distance can't be blank"
    page.should have_content "Effort can't be blank"

  end

  scenario "other date and distance validations" do

    click_link 'Log New Run'

    fill_in('Date', :with => "13/13/2000")
    fill_in('Distance', :with => "a")

    click_button 'Submit'

    page.should have_content "Date should be in the following format "
    page.should have_content "Distance is not a number"

  end

  scenario "rolling 7 day mileage is displayed" do

    (0..6).each do |x|
      run = FactoryGirl.create(:workout, user: User.first ,date: Date.today-x, distance: 2)
    end

    visit root_path

    page.should have_content "Rolling 7 day total mileage: 14.0"

  end

  scenario "last weeks total mileage is displayed" do

    (1..21).each do |x|
      run = FactoryGirl.create(:workout, user: User.first ,date: Date.today-x, distance: 2)
    end

    visit root_path

    page.should have_content "Last weeks total mileage: 14.0"
  end

  # need js driver since were using js to hyperlink the table row
  scenario "user can view and edit an existing run", :js => true do

    FactoryGirl.create(:workout, user: User.first, date: Date.today, distance: 3, note: "Search for ME")

    visit root_path

    # click anywhere on the table row
    page.find(:xpath,"//*[text()='Search for ME']").click

    # should see update button
    find_button "Update"
  end

  scenario "chart weekly mileage", :js => true do

    (1..69).each do |x|
      run = FactoryGirl.create(:workout, user: User.first ,date: Date.today-x, distance: Random.rand(2.0..5.0))
    end

    visit root_path

    # should see the chart div
    page.should have_css "div#chart-1"
  end

  scenario "if yesterday was a hard run training partner should suggest an easy run" do
    FactoryGirl.create(:workout, user: User.first, date: Date.yesterday, effort: Workout::EFFORT_LIST.last, distance: Random.rand(4.0..6.0))

    # since we have no other mileage history we'll see the default recommendation for 1.5
    visit root_path

    page.should have_content "Easy 1.5 mile run to recover from yesterdays hard effort"

  end

  scenario "a long run should be recommended if there is space for in the rolling total" do

    # Probably want to create some helpers for creating previous weeks worth of runs
    Date.today.last_week.beginning_of_week.upto(Date.today.last_week.end_of_week) do |day|
      FactoryGirl.create(:workout, user: User.first ,date: day, distance: 4)
    end

    # change some numbers so this test works on mondays, el oh el
    Workout.first.update_attributes(:distance => 7)
    Workout.last.update_attributes(:distance => 1)

    visit root_path

    page.should have_content "Moderate 7.0 mile long run"

  end

  scenario "a long run should be recommended if there is space in the current week as well as the rolling total" do

    Timecop.travel(Time.zone.local(2016, 11, 27,12)) do

      # fill in the previous week
      Date.today.last_week.beginning_of_week.upto(Date.today.last_week.end_of_week) do |day|
        FactoryGirl.create(:workout, user: User.first ,date: day, distance: 4)
      end

      # low mileage this week
      Date.today.beginning_of_week.upto(Date.today.end_of_week - 1) do |day|
        FactoryGirl.create(:workout, user: User.first ,date: day, distance: 2)
      end

      visit root_path

      page.should have_content "Moderate 7.0 mile long run"

    end

  end

end
