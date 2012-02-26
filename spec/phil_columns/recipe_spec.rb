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

    context 'when given no recipe file' do

      let :instance do
        described_class.new nil
      end

      it "should raise an error" do
        expect { instance }.should raise_error( 'Please provide a recipe file path' )
      end

    end

    context 'when given an non-esistent recipe file' do

      let :instance do
        described_class.new File.join( temp_path, 'non_existent_recipe.rb' )
      end

      it "should raise an error" do
        expect { instance }.should raise_error( 'Recipe file does not exist' )
      end

    end

  end

  context '#move_files' do

    let :recipe_name do
      :move_files
    end

    it "should successfully execute the move files command" do
      instance.should_receive :move_files
      instance.execute!
    end

  end

  context '#remove_files' do

    let :recipe_name do
      :remove_files
    end

    it "should successfully execute the remove files command" do
      instance.should_receive :remove_files
      instance.execute!
    end

  end


end
