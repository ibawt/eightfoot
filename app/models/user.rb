class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :rememberable, :trackable, :validatable, :omniauthable,
    :omniauth_providers => [:github]

  has_many :project_users
  has_many :projects, through: :project_users

  def self.find_for_github_auth(auth)
    where(auth.slice(:provider,:uid)).first_or_initialize.tap do |user|
      if (user.persisted? and user.type == "InvitedUser") or !user.persisted?
        user.provider = auth.provider
        user.uid = auth.uid
        user.email = auth.info.email
        user.password = Devise.friendly_token[0,20]
        user.name = auth.info.name
        user.image = auth.info.image
        user.github_uid = auth.info.uid
        user.nickname = auth.info.nickname
        user.token = auth.credentials.token
        user.expires = auth.credentials.expires
        user.type = "RegularUser"
        user.save!
      end
    end
  end
end
