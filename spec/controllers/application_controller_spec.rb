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
      it "should assign the client from prepare_github if its not assigned already"
      it "should grab the user and login"
      it "should return the assigned client if it's there already"
    end
  end
end
