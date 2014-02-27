class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy, :show_repos, :update_position]

  # GET /projects
  # GET /projects.json
  def index
    @projects = Project.all
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
  end

  def update_position
    params[:issues].each_value do |issue|
      my_issue = Issue.find(issue['id'].to_i)
      coords = issue['coords']
      my_issue.row = coords['row'].to_i
      my_issue.col = coords['col'].to_i
      my_issue.width = coords['size_x'].to_i
      my_issue.height = coords['size_y'].to_i
      my_issue.save
    end
    render json: {}, :status => :ok
  end

  def add_repos
    @repo = Repository.create(params.require(:repository).permit(:slug))
    @repo.save

    redirect_to show_repos_project_path
  end

  def show_repos
    @repos = @client.repos
    @repos.each do |repo|
      r = Repository.find_or_create_by(:slug => repo.full_name)
      r.save if r.changed?

      r.destroy unless repo.has_issues
    end

    @repos = Repository.all
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(project_params)

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

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
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

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url }
      format.json { head :no_content }
    end
  end

  private
  def set_project
    @project = Project.find(params[:id] || params[:project_id])
  end

  def project_params
    params.require(:project).permit(:name, :repository_ids => [])
  end
end
