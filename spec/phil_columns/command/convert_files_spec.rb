require 'spec_helper'
require File.expand_path( "#{File.dirname __FILE__}/files_like_matching_sharedspec" )

describe PhilColumns::Command::ConvertFiles do

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

  it "should be concerned with PhilColumns::Command::FilesLikeMatching" do
    described_class.should include( PhilColumns::Command::FilesLikeMatching )
  end
  it_should_behave_like 'concerned with FilesLikeMatching'

end
