class Repository < ActiveRecord::Base
  belongs_to :project

  def name
    slug
  end
end
