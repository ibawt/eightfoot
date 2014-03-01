class Project < ActiveRecord::Base
  has_many :repositories, through: :project_repositories
  has_many :project_repositories

  has_many :labels, through: :project_labels
  has_many :project_labels

  has_many :issues

  validates :name, presence: true
  validates :max_issues, numericality: {greater_than: 0, only_integer: true}

  def column_headers
    result = YAML::load(headers || '')
    result ? result : {}
  end
end
