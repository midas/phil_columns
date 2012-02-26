require 'spec_helper'

describe PhilColumns::Command::MoveFiles do

  after :each do
    remove_test_environment
  end

  let :instance do
    described_class.new base_path do
      like /^\d+_\d+_\d{4}.txt$/
      to "originals"
    end
  end

  let :base_path do
    temp_path
  end

  let :test_dir do
    'test_dir'
  end

  context "given like and to" do

    before :each do
      touch_test_files 10
    end

    context "when like is a Regexp" do

      before :each do
        instance.send( :_like=, /test_file_\d\.txt/ )
      end

      context "and to is a relative path" do

        before :each do
          instance.send( :_to=, test_dir )
        end

        it "should correctly resolve a list of files to move" do
          instance.send( :files_from_like ).should == {
            File.join( base_path, 'test_file_1.txt' ) => File.join( base_path, test_dir, 'test_file_1.txt' ),
            File.join( base_path, 'test_file_2.txt' ) => File.join( base_path, test_dir, 'test_file_2.txt' ),
            File.join( base_path, 'test_file_3.txt' ) => File.join( base_path, test_dir, 'test_file_3.txt' ),
            File.join( base_path, 'test_file_4.txt' ) => File.join( base_path, test_dir, 'test_file_4.txt' ),
            File.join( base_path, 'test_file_5.txt' ) => File.join( base_path, test_dir, 'test_file_5.txt' ),
            File.join( base_path, 'test_file_6.txt' ) => File.join( base_path, test_dir, 'test_file_6.txt' ),
            File.join( base_path, 'test_file_7.txt' ) => File.join( base_path, test_dir, 'test_file_7.txt' ),
            File.join( base_path, 'test_file_8.txt' ) => File.join( base_path, test_dir, 'test_file_8.txt' ),
            File.join( base_path, 'test_file_9.txt' ) => File.join( base_path, test_dir, 'test_file_9.txt' )
          }
        end

      end

    end

    context "when like is a Regexp" do

      before :each do
        instance.send( :_like=, "*.txt" )
      end

      context "and to is a relative path" do

        before :each do
          instance.send( :_to=, test_dir )
        end

        it "should correctly resolve a list of files to move" do
          instance.send( :files_from_like ).should == {
            File.join( base_path, 'test_file_1.txt' )  => File.join( base_path, test_dir, 'test_file_1.txt' ),
            File.join( base_path, 'test_file_2.txt' )  => File.join( base_path, test_dir, 'test_file_2.txt' ),
            File.join( base_path, 'test_file_3.txt' )  => File.join( base_path, test_dir, 'test_file_3.txt' ),
            File.join( base_path, 'test_file_4.txt' )  => File.join( base_path, test_dir, 'test_file_4.txt' ),
            File.join( base_path, 'test_file_5.txt' )  => File.join( base_path, test_dir, 'test_file_5.txt' ),
            File.join( base_path, 'test_file_6.txt' )  => File.join( base_path, test_dir, 'test_file_6.txt' ),
            File.join( base_path, 'test_file_7.txt' )  => File.join( base_path, test_dir, 'test_file_7.txt' ),
            File.join( base_path, 'test_file_8.txt' )  => File.join( base_path, test_dir, 'test_file_8.txt' ),
            File.join( base_path, 'test_file_9.txt' )  => File.join( base_path, test_dir, 'test_file_9.txt' ),
            File.join( base_path, 'test_file_10.txt' ) => File.join( base_path, test_dir, 'test_file_10.txt' )
          }
        end

      end

    end

  end

  context "given a list of source and dest file locations" do

    before :each do
      touch_test_file
      File.file?( default_test_file_path ).should be_true

      instance.stub!( :files_from_like ).and_return files
    end

    let :files do
      {
        default_test_file_path => File.join( test_dir_path, default_test_file_name )
      }
    end

    it "should successfully move a file" do
      instance.execute!
      File.file?( default_test_file_path ).should be_false
      File.file?( File.join( test_dir_path, default_test_file_name ) ).should be_true
    end

  end

end
