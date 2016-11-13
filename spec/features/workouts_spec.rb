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

    click_button 'Create Workout'

    # expect to see the run we just logged
    page.should have_content("2.73")

  end

  scenario "model presence validations" do

    click_link 'Log New Run'

    click_button 'Create Workout'

    page.should have_content "Date can't be blank"
    page.should have_content "Distance can't be blank"
    page.should have_content "Effort can't be blank"

  end

  scenario "other date and distance validations" do

    click_link 'Log New Run'

    fill_in('Date', :with => "13/13/2000")
    fill_in('Distance', :with => "a")

    click_button 'Create Workout'

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

    (2..21).each do |x|
      run = FactoryGirl.create(:workout, user: User.first ,date: Date.today-x, distance: 2)
    end

    visit root_path

    page.should have_content "Last weeks total mileage: 14.0"
  end

end
