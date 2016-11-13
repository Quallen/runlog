class Workout < ActiveRecord::Base
  belongs_to :user

  validates :date, presence: true
  validates :distance, presence: true, numericality: true
  validates :effort, presence: true

  validate :date_valid?

  EFFORT_LIST = ['easy / recovery', 'moderate', 'difficult / workout']

  def date_valid?
    errors.add(:date, "should be in the following format: mm/dd/yyyy") unless date.present? && date.is_a?(ActiveSupport::TimeWithZone)
  end

end
