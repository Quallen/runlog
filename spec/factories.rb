require 'spec_helper'

FactoryGirl.define do
  factory :user do |u|
    u.email "test@test.com"
    u.password "factoryPassword1!"
  end
end
