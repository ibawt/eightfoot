class ApplicationController < ActionController::Base
  include GithubHelper

  protect_from_forgery with: :exception

  before_filter :authenticate_user!
  before_filter :prepare_github
end
