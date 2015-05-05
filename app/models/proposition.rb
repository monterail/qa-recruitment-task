class Proposition < ActiveRecord::Base
  belongs_to :owner, class_name: 'User'
  belongs_to :jubilat, class_name: 'User'
  has_many :comments

  validates :title, presence: true

  scope :chosen, -> { where.not(year_chosen_in: nil) }
  scope :current, -> { where(year_chosen_in: nil) }
end
