FactoryGirl.define do
  factory :user do |u|
    u.email "test@test.com"
    u.password "factoryPassword1!"
  end
end

FactoryGirl.define do
  factory :workout do |r|
    r.date "01/01/1970"
    r.distance "3.14"
    r.effort Workout::EFFORT_LIST.first
    r.note "totally a note"
  end
end
