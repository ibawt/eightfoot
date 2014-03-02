class IssuesController < ApplicationController
  before_action :set_project, only: [:index]
  before_action :set_issue, only: [:show, :edit, :update, :destroy]

  before_action :get_milestones

  def index
    # this is kind of ugly but it works
    @issue_map = {}
    @project.repositories.each do |repo|
      milestone = find_milestone(repo) if milestone_filtered?
      update_issue_map(all_issues(repo, milestone),repo) if !milestone_filtered? || milestone
    end
    @issues = @project.issues.where( :gh_id => @issue_map.values.collect {| each | each[:issue].id} )

    if params[:labels]
      @labels = params[:labels].split(",")
    else
      @labels = @project.labels.collect(&:name)
    end
  end

  def update_issue_map(issues,repo)
    existing_issues = Issue.where(gh_id: issues.collect(&:id))
    unsaved_issues = issues.select {|incoming| (existing_issues.detect {|existing| existing.gh_id==incoming.id}).nil?}
    unsaved_issues.map! {|unsaved| unsaved = Issue.new(gh_id: unsaved.id, project: @project, repository: repo)}
    Issue.import(unsaved_issues)
    existing_issues = Issue.where(gh_id: issues.collect(&:id))
    issues.each { |issue|
      found_issue = existing_issues.detect{|e| e.gh_id== issue.id}
      @issue_map[found_issue.id]={ issue: issue, repo: repo }
    }
  end

  def get_milestones
    @milestones = @project.repositories.reduce([]) do |acc, repo|
      acc + @client.get("/repos/#{repo.slug}/milestones")
    end
    @milestones = @milestones.collect(&:title).to_set
  end

  def show
  end

  def edit
  end

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

  def set_issue
    @issue = Issue.find(params[:id])
  end

  def issue_params
    params[:issue]
  end

  def milestone_filtered?
    !(params[:milestone].nil? || params[:milestone] == "all")
  end

  def labels_for_repo(repo)
    labels = @project.labels.where(repository: repo).collect(&:name).join(',')
    # only include filters from query params, if query params exist
    labels = params[:labels] if params[:labels]

    labels
  end

  def all_issues(repo, milestone = nil)
    opts = { per_page: [100, @project.max_issues].min, sort: 'updated' }
    opts[:labels] = labels_for_repo(repo)
    opts[:milestone] = milestone if milestone
    issues = @client.list_issues(repo.slug, opts)
    next_request = @client.last_response.rels[:next]
    while issues.size < @project.max_issues && next_request do
      req = next_request.get
      issues +=  req.data
      next_request = req.rels[:next]
    end
    issues
  end

  def find_milestone(repo)
    milestones = @client.get("/repos/#{repo.slug}/milestones") if milestone_filtered?
    milestone = milestones.detect{ |milestone| milestone.title == params[:milestone] } if milestone_filtered?
    milestone.number if milestone
  end

end
