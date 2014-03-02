class Label < ActiveRecord::Base
  belongs_to :project
  belongs_to :repository

  validates :name, presence: true
end
