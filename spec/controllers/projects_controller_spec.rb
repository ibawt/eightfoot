require 'spec_helper'

describe ProjectsController, :vcr  do
  user = FactoryGirl.create(:user)
  login_user(user)

  unauthorized_user = FactoryGirl.create(:user)

  let(:project) {
    project = FactoryGirl.create(:project_with_repositories)
    project.users << user
    project
  }

  describe 'unauthorized users' do
    login_user(unauthorized_user)
    it "cannot see other user's projects in index" do
      get :index
      response.status.should eq(200)
      assigns(:project).should_not eq(project)
    end
    it "cannot see other user's projects in show" do
      expect {
        get :show, id: project
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
    it "cannot edit other people's projects" do
      expect {
        put :update, id: project, name: 'foobaz'
      }.to raise_error{ActiveRecord::RecordNotFound}
    end
    it "cannot destroy other people's projects" do
      expect {
        post :destroy, id: project
      }.to raise_error{ActiveRecord::RecordNotFound}
    end
    it "cannot update the headers of another user's project" do
      expect {
        post :change_heading, project_id: project, heading: { col_number: 1, value: "foo" }
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
    it "cannot get the labels of another user's project" do
      expect {
        get :add_labels, id: project
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
    describe 'trying to change issue positions' do
      let(:test_issues) {
        create_list( :issue, 3, project: project)
      }

      let(:test_params) {
        { test_issues[0].id => { row: 2, col: 2 }, test_issues[1].id => { row: 1, col: 1 } }
      }

      it "are blocked from doing so" do
        expect {
          post :update_position, project_id: project, issues: test_params
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
    it "cannot add repos to another user's project"
    it "cannot add users to another user's project" do
      expect {
        post :add_user, id: project, username: "qq99"
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
    it "cannot view a list of users to add to another user's project" do
      expect {
        get :add_users, id: project
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
    it "cannot remove users from another user's project" do
      expect {
        post :remove_user, id: project, username: "qq99"
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe "#index" do
    it "populates the projects array" do
      get :index
      assigns(:projects).should eq([project])
    end
    it "render the index view" do
      get :index
      response.should render_template :index
    end
  end

  describe "#show" do
    it "populates the one project" do
      get :show, id: project
      assigns(:project).should eq(project)
    end
    it "renders the show view" do
      get :show, id: project

      response.should render_template :show
    end
  end

  describe "#new" do
    it "creates a new project for population" do
      Project.should_receive(:new)
      get :new
      assigns(:project)
    end
    it "renders the new view" do
      get :new
      response.should render_template :new
    end
  end

  describe "POST #change_heading" do
    let(:heading_params) { { col_number: 1, value: "foo" } }

    it "should change the value of the column in the db" do
      post :change_heading, project_id: project, heading: heading_params
      expect(project.reload.column_headers).to eq( { '1' => "foo" } )
    end

    it "should handle a nil value for the header" do
      expect {
        post :change_heading, project_id: project, heading: heading_params
      }.to_not raise_error
    end

    it "should require the heading" do
      expect {
        post :change_heading, project_id: project
      }.to raise_error(ActionController::ParameterMissing)
    end

    it "should render an empty json response with ok on success" do
      post :change_heading, project_id: project, heading: heading_params
      expect(assert_response :ok)
    end
    it "should merge the data with the old" do
      project.update(headers: { "2" => "bar" })
      post :change_heading, project_id: project, heading: heading_params
      expect(project.reload.column_headers).to eq( { "1" => "foo", "2" => "bar" } )
    end
  end

  describe "GET #add_labels" do
    it "should populate repos with the projects repos" do
      get :add_labels, id: project
      assigns(:repos).should eq(project.repositories)
    end

    it "should retreive the labels for each repo" do
      Octokit::Client.any_instance.should_receive(:labels).with('ibawt/eightfoot').once.and_return([])
      get :add_labels, id: project
    end

    # broken?? this is a get
    it "should save the new label associated with the repo" do
      get :add_labels, id: project
      %w(bug duplicate enhancement invalid question wontfix design security).each do |name|
        expect(Label.where(name: name)).to exist
      end
    end
  end

  describe "POST #update_position" do
    let(:test_issues) {
      create_list( :issue, 3, project: project)
    }

    let(:test_params) {
      { test_issues[0].id => { row: 2, col: 2 }, test_issues[1].id => { row: 1, col: 1 } }
    }

    it "will render a refresh response if you werent the last edit" do
      controller.should_receive(:needs_refresh?).and_return(true)
      post :update_position, project_id: project
      expect(response.status).to eq(423)
    end
    it "will iterate over each issue and save the row/col" do
      post :update_position, project_id: project, issues: test_params
      expect(test_issues[0].reload.row).to eq 2
      expect(test_issues[0].reload.col).to eq 2
      expect(test_issues[1].reload.row).to eq 1
      expect(test_issues[1].reload.col).to eq 1
    end

    it "will update the LastEdit" do
      expect {
        post :update_position, project_id: project, issues: test_params
      }.to change(LastEdit, :count).by 1
      expect(response.status).to eq 200
    end
  end

  describe "POST #add_repos" do
    it "should only respond to repository and slug"
    it "should fail if theres no github repo of that name"
    it "should redirect to show_repos on success"
  end

  describe "search_repos" do
    it "should search github for the repo"
    it "should respond with json with the full_names"
  end

  describe "GET #show_repos" do
    it "should query gh for the available repos"
    it "should create a local repo for each remote repo"
    it "shouldn't create a repo if theres no issues enabled"
    it "should populate the repos list with all the repos"
  end

  describe "create" do
    it "should create a new project with the supplied params"
    it "should redirect on save to the project and set a notice"
    it "should show errors on save returning false"
  end

  describe "destroy" do
    it "should destroy the project" do
      post :destroy, id: project
      expect {
        project.reload
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
    it "should redirect to the projects index"
  end

  describe "update" do
    it "should update the params and redirect to the show page"
    it "should render errors on validation errors"
  end
end
