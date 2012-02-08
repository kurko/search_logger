require "spec_helper"

describe SearchLogger::Exec, wip: true do
  let(:valid_argv){ [File.expand_path("../../support/file_repository/exported_from_persistence.csv", __FILE__)] }
  let(:invalid_argv){ ["invalid_file/path.rb"] }

  module Kernel
    def puts(str); nil; end
  end

  context "initializing with a valid file" do
    subject { SearchLogger::Exec.new(valid_argv) }

    it "should initialize if an existent file was specified" do
      subject.should be_true
    end

    it "should initialize if a file was specified" do
      subject.argv.should == valid_argv
    end
  end

  context "initializing with an invalid file" do
    it "should not initialize" do
      lambda { SearchLogger::Exec.new(invalid_argv) }.should raise_error SystemExit
    end
  end  
end