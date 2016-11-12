require 'spec_helper'

feature 'workout tests' do

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

    screenshot_and_save_page

  end

end
