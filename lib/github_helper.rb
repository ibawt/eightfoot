module GithubHelper
  def prepare_github
    begin
      if Rails.env.test?
        @client = Octokit::Client.new :access_token => ENV['TEST_API_TOKEN']
      else
        @client = Octokit::Client.new :access_token => current_user.token
      end
      @gh_user = @client.user
      @gh_user.login
    rescue
    end
  end
end
