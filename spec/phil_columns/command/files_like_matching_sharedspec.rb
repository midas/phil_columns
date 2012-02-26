require 'spec_helper'

shared_examples_for 'concerned with FilesLikeMatching' do

  context "given like" do

    before :each do
      touch_test_files 10
    end

    context "when like is a Regexp" do

      before :each do
        instance.send( :_like=, /test_file_\d\.txt/ )
      end

      it "should correctly resolve a list of files to move" do
        instance.send( :files_from_like ).should == [
          File.join( base_path, 'test_file_1.txt' ),
          File.join( base_path, 'test_file_2.txt' ),
          File.join( base_path, 'test_file_3.txt' ),
          File.join( base_path, 'test_file_4.txt' ),
          File.join( base_path, 'test_file_5.txt' ),
          File.join( base_path, 'test_file_6.txt' ),
          File.join( base_path, 'test_file_7.txt' ),
          File.join( base_path, 'test_file_8.txt' ),
          File.join( base_path, 'test_file_9.txt' )
        ]
      end

    end

  end

end
