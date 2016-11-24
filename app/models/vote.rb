class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :proposition

  validates :proposition_id, :user_id, presence: true
  validates :user_id, uniqueness: { scope: :proposition_id }
end
