class UsersController < ApplicationController

  def index
    binding.pry
    @user = current_user
  end

  def show
  end
end
