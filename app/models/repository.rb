class Repository < ActiveRecord::Base
  belongs_to :project
  has_many :labels

  validates :slug, presence: true

  def name
    slug
  end
end
