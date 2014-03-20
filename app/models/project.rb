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

    # get all orgs
    client.organizations.each do |gh_org|
      orgs << client.get(gh_org.rels[:self].href, opts)
    end

    # paginate over each orgs' members
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

  def detailed_users(client)
    details = []
    users.each do |u|
      details << client.user(u.nickname)
    end
    details
  end

  def invite_user(client, github_nickname)
    user_info = client.user(github_nickname)

    user = InvitedUser.find_or_initialize_by_nickname(
      :email => user_info.email,
      :image => user_info.rels[:avatar].href,
      :nickname => github_nickname,
      :uid => user_info.id,
      :name => user_info.name
    )

    user.transaction do
      user.save(:validate => false)
      self.users << user

      return self.save
    end
  end
end
