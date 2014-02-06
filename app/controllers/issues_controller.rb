class IssuesController < ApplicationController
  before_action :set_project, only: [:index]
  before_action :set_issue, only: [:show, :edit, :update, :destroy]


  # GET /issues
  # GET /issues.json
  def index
    issues = @project.repositories.collect(&:slug).map { |repo| @client.list_issues(repo) }.flatten
    issues.each do |i|
      issue = Issue.find_or_create_by(:number => i.number)
      issue.project = @project
      issue.update(i.attrs.except(:user, :assignee, :labels, :milestone, :created_at, :updated_at, :pull_request, :id))
      issue.save if issue.changed?
    end

    @issues = @project.issues
  end

  # GET /issues/1
  # GET /issues/1.json
  def show
  end

  # GET /issues/new
  def new
    @issue = Issue.new
  end

  # GET /issues/1/edit
  def edit
  end

  # POST /issues
  # POST /issues.json
  def create
    @issue = Issue.new(issue_params)

    respond_to do |format|
      if @issue.save
        format.html { redirect_to @issue, notice: 'Issue was successfully created.' }
        format.json { render action: 'show', status: :created, location: @issue }
      else
        format.html { render action: 'new' }
        format.json { render json: @issue.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /issues/1
  # PATCH/PUT /issues/1.json
  def update
    respond_to do |format|
      if @issue.update(issue_params)
        format.html { redirect_to @issue, notice: 'Issue was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @issue.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /issues/1
  # DELETE /issues/1.json
  def destroy
    @issue.destroy
    respond_to do |format|
      format.html { redirect_to issues_url }
      format.json { head :no_content }
    end
  end

  private
  def set_project
    @project = Project.find(params[:project_id])
  end


    # Use callbacks to share common setup or constraints between actions.
    def set_issue
      @issue = Issue.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def issue_params
      params[:issue]
    end
end
