class Label < ActiveRecord::Base
  belongs_to :project
  belongs_to :repository
  has_many :issues, through: :issue_labels
  has_many :issue_labels

  validates :name, presence: true
end
