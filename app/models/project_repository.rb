class ProjectRepository < ActiveRecord::Base
  belongs_to :repository
  belongs_to :project
end
