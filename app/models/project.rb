class Project < ActiveRecord::Base
  has_many :repositories, through: :project_repositories
  has_many :project_repositories

  has_many :issues, :order => :position
end
