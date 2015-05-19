class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :proposition

  validates :proposition_id, :user_id, presence: true
end
