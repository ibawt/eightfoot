module GithubHelper
  def prepare_github
    begin
      user = current_user
      @client = Octokit::Client.new :access_token => user.token

      @gh_user = @client.user
      @gh_user.login
    rescue
      binding.pry
    end
  end
end
