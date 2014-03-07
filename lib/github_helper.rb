module GithubHelper
  def prepare_github
    if Rails.env.test?
      Octokit::Client.new :access_token => ENV['TEST_API_TOKEN']
    else
      Octokit::Client.new :access_token => current_user.token
    end
  end

  def github_client
    unless @client
      @client = prepare_github
      @gh_user = @client.user
      @gh_user.login
    end
    @client
  end
end
