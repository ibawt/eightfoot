class IssuesController < ApplicationController
  before_action :set_project, only: [:index]
  before_action :set_issue, only: [:show, :edit, :update, :destroy]

  before_action :get_milestones

  MAX_ISSUES_PER_PROJECT = 50

  def index
    # this is kind of ugly but it works
    @issue_map = {}
    @project.repositories.each do |repo|
      update_issue_map(all_issues(repo, find_milestone),repo)
    end
    @issues = @project.issues.where( :gh_id => @issue_map.values.collect(&:id) )
  end

  def update_issue_map(issues,repo)
    existing_issues = Issue.where(gh_id: issues.collect(&:id))
    unsaved_issues = issues.select {|incoming| (existing_issues.detect {|existing| existing.gh_id==incoming.id}).nil?}
    unsaved_issues.map! {|unsaved| unsaved = Issue.new(gh_id: unsaved.id, project: @project, repository: repo)}
    Issue.import(unsaved_issues)
    existing_issues = Issue.where(gh_id: issues.collect(&:id))
    issues.each { |issue|
      found_issue = existing_issues.detect{|e| e.gh_id== issue.id}
      @issue_map[found_issue.id]=issue
    }
  end

  def get_milestones
    @milestones = @project.repositories.reduce([]) do |acc, repo|
      acc + @client.get("/repos/#{repo.slug}/milestones")
    end
  end

  # GET /issues/1
  # GET /issues/1.json
  def show
  end

  # GET /issues/1/edit
  def edit
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

  private

  def all_issues(repo, milestone = nil)
    opts = { per_page: 100 }
    opts[:labels] = @project.labels.collect(&:name).join(',')
    opts[:milestone] = milestone if milestone
    issues = @client.list_issues(repo.slug, opts)
    max=0
    while max < MAX_ISSUES_PER_PROJECT/opts[:per_page] && (rels = @client.last_response.rels[:next]).nil? do
      issues +=  rels.get.data
      max += 1
    end
    issues
  end

  def find_milestone
    milestones = get_milestones.collect(&:number)
    milestone = params[:milestone] if params[:milestone] && milestones.include?(params[:milestone].to_i)
    milestone
  end
end
