class Proposition < ActiveRecord::Base
  belongs_to :owner, class_name: 'User'
  belongs_to :jubilat, class_name: 'User'
  has_many :comments

  validates :title, presence: true
end
