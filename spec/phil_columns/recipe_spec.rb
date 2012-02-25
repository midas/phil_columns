require 'spec_helper'

describe PhilColumns::Recipe do

  before :each do
    touch_test_file File.join( temp_path, '01_01_2010.txt' )
    create_recipe_file recipe_name
  end

  after :each do
    remove_test_environment
  end

  let :instance do
    described_class.new default_recipe_file_path
  end

  context '#initialize' do

    let :recipe_name do
      :move_files
    end

    it "should have the correct instuctions" do
      instance.instructions.should == send( "#{recipe_name}_recipe_file_contents" )
    end

  end

  context '#move_files' do

    let :recipe_name do
      :move_files
    end

    it "should successfully move the file" do
      instance.should_receive :move_files
      instance.execute!
    end

  end

end
