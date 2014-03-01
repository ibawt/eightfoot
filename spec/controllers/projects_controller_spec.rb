require 'spec_helper'

describe ProjectsController do
  describe "#index" do
    it "populates the projects arrayfdsfds"
    it "render the index view"
  end

  describe "#show" do
    it "populates the one project"
    it "renders the show view"
  end

  describe "#new" do
    it "creates a new project for population"
    it "renders the new view"
  end

  describe "POST #change_heading" do
    it "should change the value of the column in the db"
    it "should handle a nil value for the header"
    it "should respond to the heading"
    it "should render an empty json response with ok on success"
    it "should merge the data with the old"
  end

  describe "GET #add_labels" do
    it "should populate repos with the projects repos"
    it "should retreive the labels for each repo"
    it "should save the new label associated with the repo"
  end

  describe "POST #update_position" do
    it "will render a refresh response if you werent the last edit"
    it "will iterate over each issue and save the row/col"
    it "will update the LastEdit"
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
    it "should destroy the project"
    it "should redirect to the projects index"
  end

  describe "update" do
    it "should update the params and redirect to the show page"
    it "should render errors on validation errors"
  end
end
