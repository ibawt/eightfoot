class Repository < ActiveRecord::Base
  belongs_to :project

  validates :slug, presence: true

  def name
    slug
  end
end
