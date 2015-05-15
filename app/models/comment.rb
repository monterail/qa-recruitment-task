class Comment < ActiveRecord::Base
  belongs_to :owner, class_name: 'User'
  belongs_to :proposition

  validates :body, :owner_id, :proposition_id, presence: true
end
