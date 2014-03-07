require 'spec_helper'

describe ApplicationController do
  login_user

  describe "github helper tests" do
    describe "prepare_github" do
      it "should use the TEST_API_TOKEN env variable if present" do
        expect( ENV ).to receive(:[]).with('TEST_API_TOKEN').and_return('foobar')
        expect( Octokit::Client).to receive(:new).with(:access_token => 'foobar')
        controller.prepare_github
      end
      it "should use the current_user's token if no env variable is present" do
        expect(Rails.env).to receive(:test?).and_return(false)
        expect(Octokit::Client).to receive(:new).with(access_token: 'foobar-baz')
        expect(controller.current_user).to receive(:token).and_return('foobar-baz')
        controller.prepare_github
      end
    end

    describe "github_client tests" do
      let(:gh_user) { {:login => ""} }
      let(:client) { {:user => gh_user} }

      before(:each) do
        expect(controller).to receive(:prepare_github).once.and_return(client)
        expect(client).to receive(:user).once.and_return(gh_user)
        expect(gh_user).to receive(:login).once
      end

      it "should assign the client from prepare_github if its not assigned already" do
        assigns(:client)
        controller.github_client
      end

      it "should grab the user and login" do
        assigns(:gh_user)
        controller.github_client
      end

      it "should return the assigned client if it's there already" do
        controller.github_client
        controller.github_client
      end
    end
  end
end
