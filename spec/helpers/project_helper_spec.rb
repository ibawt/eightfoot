require 'spec_helper'
  class ProjectsHelperTest
    include ProjectsHelper

    def initialize(project)
      @project = project
    end
  end

  describe ProjectsHelper do
   let(:project) { FactoryGirl.create(:project_with_repositories) }


    describe '#column_header' do

      it "should return a blank string if no column headers present" do
        ProjectsHelperTest.new(project).column_header(2).should eq('')
      end
    end
  end

