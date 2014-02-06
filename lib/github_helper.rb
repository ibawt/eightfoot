module GithubHelper
  def prepare_github
    user = current_user
    @client = Octokit::Client.new :access_token => user.token

    @gh_user = @client.user
    @gh_user.login
  end
end
