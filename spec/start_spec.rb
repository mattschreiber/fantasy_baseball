require_relative '../config/environment'
require 'rails_helper'

feature "Fantasy Baseball Setup Tests" do
	before :all do
        $continue = true
    end

    around :each do |example|
        if $continue
            $continue = false 
            example.run 
            $continue = true unless example.exception
        else
            example.skip
        end
    end

    #helper method to determine if Ruby class exists as a class
    def class_exists?(class_name)
      eval("defined?(#{class_name}) && #{class_name}.is_a?(Class)") == true
    end

    context "rq1.0" do
      it "must have top level structure of a rails application" do
        expect(File.exists?("Gemfile")).to be(true)
        expect(Dir.entries(".")).to include("app", "bin", "config", "db", "lib", "public", "log", "test", "vendor")
        expect(Dir.entries("./app")).to include("assets", "controllers", "helpers", "mailers", "models", "views")        
      end
    end

    context "rq1.1" do #'Owner' model and database table
      context "Owner Model:" do
        it "Owner class created" do
          expect(class_exists?("Ownder"))
          expect(Owner < ActiveRecord::Base).to eq(true)        
        end
        context "Owner class properties added" do
          subject(:owner) { Owner.new }
          it { is_expected.to respond_to(:first_name) } 
          it { is_expected.to respond_to(:last_name) } 
          it { is_expected.to respond_to(:team_name) }
          it { is_expected.to respond_to(:created_at) } 
          it { is_expected.to respond_to(:updated_at) } 
        end
        it "Owner database structure in place" do
          # rails g model owner first_name last_name team_name 
          # rake db:migrate
          expect(Owner.column_names).to include "first_name", "last_name", "team_name"
          expect(Owner.column_types["first_name"].type).to eq :string
          expect(Owner.column_types["last_name"].type).to eq :string
          expect(Owner.column_types["team_name"].type).to eq :string	
          expect(Owner.column_types["created_at"].type).to eq :datetime
          expect(Owner.column_types["updated_at"].type).to eq :datetime
        end
      end
    end

end