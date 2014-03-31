class Organization < ActiveRecord::Base
  has_many :users, through: :organization_users
  has_many :organization_users

  def regenerate_users(gh_client)
    gh_organization = gh_client.get(self.source)
    gh_members = gh_client.get(gh_organization.rels[:members].href)

    next_request = gh_client.last_response.rels[:next]
    while gh_members.size && next_request
      req = next_request.get
      gh_members += req.data
      next_request = req.rels[:next]
    end

    gh_members.each do |m|
      user = InvitedUser.find_or_create_by(nickname: m.login)
      user.image = m.rels[:avatar].href

      if !user.organizations.include? self
        user.organizations << self
      end
      user.save
    end
  end
end
