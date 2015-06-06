class Birthday < ActiveRecord::Base
  belongs_to :celebrant, class_name: User, foreign_key: :celebrant_id
  belongs_to :person_responsible, class_name: User, foreign_key: :person_responsible_id

  validates :celebrant, presence: true
  validates :person_responsible, presence: true
end
