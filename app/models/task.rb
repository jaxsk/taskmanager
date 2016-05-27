class Task < ActiveRecord::Base
  include PublicActivity::Model

  has_and_belongs_to_many :users
  belongs_to :creator, class_name: 'User', foreign_key: 'user_id'

  validates :title, presence: true, length: { maximum: 50 }
  validates :description, presence: true, length: { maximum: 1000 }
end
