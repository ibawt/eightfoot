require 'spec_helper'

describe ApplicationController do
  describe "github helper tests" do
    describe "prepare_github" do
      it "should use the TEST_API_TOKEN env variable if present" do
        expect( ENV ).should receive(:[]).with('TEST_API_TOKEN').and_return('foobar')
        expect( Octokit::Client).should receive(:new).with(:access_token => 'foobar')
        controller.prepare_github
      end
      it "should use the current_user's token if no env variable is present"
    end

    describe "github_client tests" do
      it "should assign the client from prepare_github if its not assigned already"
      it "should grab the user and login"
      it "should return the assigned client if it's there already"
    end
  end
end
