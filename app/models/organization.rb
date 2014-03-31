class Organization < ActiveRecord::Base
  has_many :users, through: :organization_users
  has_many :organization_users
end
