class UsersController < ApplicationController

  def index
    @user = current_user
    @client = Octokit::Client.new :access_token => @user.token
    @gh_user = @client.user
    @gh_user.login

    binding.pry
  end

  def show
  end
end
