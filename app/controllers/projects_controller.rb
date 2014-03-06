class ProjectsController < ApplicationController
  before_action :set_project, except: [:index, :new, :create]

  def index
    @projects = Project.all
  end

  def show
  end

  def new
    @project = Project.new
  end

  def edit
  end

  def change_heading
    heading = params.require(:heading).permit(:col_number, :value)
    col_number = heading['col_number']
    value = heading['value']

    current_heading_values = @project.column_headers
    current_heading_values[col_number] = value
    @project.update(headers: current_heading_values)

    render json: {}, :status => :ok
  end

  def add_labels
    @repos = @project.repositories
    @repos.each do |repo|
      repo_labels = github_client.labels("#{repo.slug}")
      repo_labels.each do |r|
        l = Label.find_or_create_by(:name => r.name, :repository => repo)
        l.save if l.changed?
      end
    end
  end

  def update_position
    if needs_refresh?
      render json: { refresh: true }, :status => :locked
    else
      issue_params = params.require(:issues)
      Issue.update(issue_params.keys, issue_params.values)
      l = LastEdit.create(:user_id => current_user.id)
      render json: {last_edit: l}, :status => :ok
    end
  end

  def add_repos
    begin
      repo_params = params.require(:repository).permit(:slug)
      gh_repo = github_client.get("repos/#{repo_params[:slug]}") if repo_params[:slug]
      if gh_repo
        @repo = Repository.create(repo_params)
        @repo.save if gh_repo
      end
    rescue
      flash[:error] = "No such repo #{params[:slug]}" unless gh_repo
    end

    redirect_to show_repos_project_path
  end

  def add_users
    @repos = @project.repositories
    @organizations = @project.organizations(@client)
  end

  def add_user
    user = InvitedUser.find_or_initialize_by_nickname(:nickname => params[:username])

    if user.save(:validate => false)
      user.projects += @project
      if user.save(:validate => false)
        format.json { render json: {}, status: :ok }
      else
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    else
      format.json { render json: @project.errors, status: :unprocessable_entity }
    end
  end

  def search_repos
    results = github_client.get("/search/repositories?q=#{params[:term]}")
    names = results.items.collect(&:full_name)
    respond_to do | format|
      format.json { render json: names }
    end
  end

  def show_repos
    @repos = github_client.repos
    @repos.each do |repo|
      r = Repository.find_or_create_by(:slug => repo.full_name)
      r.save if r.changed?

      r.destroy unless repo.has_issues
    end

    @repos = Repository.all
  end

  def create
    @project = Project.new(project_params)
    @project.users << current_user

    respond_to do |format|
      if @project.save
        format.html { redirect_to @project, notice: 'Project was successfully created.' }
        format.json { render action: 'show', status: :created, location: @project }
      else
        format.html { render action: 'new' }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url }
      format.json { head :no_content }
    end
  end

  private

  def needs_refresh?
    false
  end

  def set_project
    @project = Project.find(params[:id] || params[:project_id])
  end

  def project_params
    params.require(:project).permit(:name,
      :max_issues,
      :display_labels,
      :repository_ids => [],
      :label_ids => [])
  end
end
