# Teams of mcm
class Team < ApplicationRecord
  has_many :users
  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
