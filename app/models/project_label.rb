class ProjectLabel < ActiveRecord::Base
  belongs_to :label
  belongs_to :project
end
