require 'spec_helper'
require File.expand_path( "#{File.dirname __FILE__}/files_like_matching_sharedspec" )

describe PhilColumns::Command::RemoveFiles do

  after :each do
    remove_test_environment
  end

  let :instance do
    described_class.new base_path do
      like /^\d+_\d+_\d{4}.txt$/
    end
  end

  let :base_path do
    temp_path
  end

  let :test_dir do
    'test_dir'
  end

  it "should include the PhilColumns::Command::BasePathedCommand module" do
    described_class.should include( PhilColumns::Command::BasePathedCommand )
  end

  it "should include the PhilColumns::Command::FilesLikeMatching module" do
    described_class.should include( PhilColumns::Command::FilesLikeMatching )
  end
  it_should_behave_like 'concerned with FilesLikeMatching'

  context "given a list of files to remove" do

    before :each do
      touch_test_file
      File.file?( default_test_file_path ).should be_true

      instance.stub!( :files_to_remove ).and_return files
    end

    let :files do
      [
        default_test_file_path
      ]
    end

    it "should successfully remove a file" do
      instance.execute!
      File.file?( default_test_file_path ).should be_false
    end

  end

end
