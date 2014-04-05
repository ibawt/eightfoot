class OrganizationsController < ApplicationController
  def regenerate_users
    organization = Organization.find(params[:id])
    organization.regenerate_users(github_client)
    organization.updated_at = Time.now
    organization.save
    redirect_to :back, notice: "Refreshed user list"
  end
end
