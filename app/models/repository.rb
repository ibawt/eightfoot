class Repository < ActiveRecord::Base
  belongs_to :project
  belongs_to :user
  has_many :labels
  has_many :issues

  validates :slug, presence: true

  def name
    slug
  end

  def labels_in_repo
    labels.collect(&:name).join(',')
  end

  def regenerate_issues(github_client)
    issues = github_client.list_issues(self.slug, per_page: 100)

    next_request = github_client.last_response.rels[:next]
    while next_request do
      req = next_request.get
      issues +=  req.data
      next_request = req.rels[:next]
    end

    # now persist all the issues we got
    issues.each do |i|
      issue = Issue.find_or_create_by(gh_id: i.id)
      # copy data from the API into our issue
      issue.assignee = i.try(:assignee).try(:login)
      issue.title = i.title
      issue.comments_count = i.comments.to_i
      issue.source = i.rels[:html].href
      issue.labels = i.labels.collect(&:name).join(",")

      if issue.assignee # try to associate it to a copy of our user object, if such an object exists
        user = User.find_by_nickname(issue.assignee)
        if user
          user.issues << issue
        end
      end
      issue.save
      user.save if user
    end
  end
end
