require 'spec_helper'

describe Recipe do

  context '#move_files' do

    before :each do
      FileUtils.touch source_file
    end

    after :each do
      FileUtils.rm dest_file
    end

    let :source_file do
      'fixtures/test_file.txt'
    end

    let :dest_file do
      'fixtures/test_dir/test_file.txt'
    end

    it "should successfully move files" do
      move_files
    end

  end

end
