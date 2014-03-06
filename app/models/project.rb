class Project < ActiveRecord::Base
  has_many :repositories, through: :project_repositories
  has_many :project_repositories

  has_many :labels, through: :project_labels
  has_many :project_labels
  has_many :users, through: :project_users
  has_many :project_users, :dependent => :destroy

  has_many :issues

  validates :name, presence: true
  validates :max_issues, numericality: {greater_than: 0, only_integer: true}

  def column_headers
    result = YAML::load(headers || '')
    result ? result : {}
  end

  def organizations(client)
    opts = { per_page: 100, sort: 'login' }
    orgs = []

    # get a rich representation of all orgs
    client.organizations.each do |gh_org|
      orgs << client.get(gh_org.rels[:self].href, opts)
    end

    # get a rich representation of all orgs' members
    orgs.each do |org|
      clients = []
      gh_members = client.get(org.rels[:members].href)
      next_request = client.last_response.rels[:next]

      while gh_members.size && next_request
        req = next_request.get
        gh_members += req.data
        next_request = req.rels[:next]
      end
      org.members = gh_members
    end
    orgs
  end
end
