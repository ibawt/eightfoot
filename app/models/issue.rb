class Issue < ActiveRecord::Base
  belongs_to :project
  belongs_to :repository
end
