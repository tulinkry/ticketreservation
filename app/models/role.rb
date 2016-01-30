# Role
class Role < ActiveRecord::Base
  has_many :users
  validates :name, presence: true, inclusion: { in: %w(user admin) }
end
