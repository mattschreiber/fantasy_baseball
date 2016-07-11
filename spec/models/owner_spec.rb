require 'rails_helper'

RSpec.describe Owner, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
	# feature "Fantasy Baseball Setup Tests" do
	before :all do
		Owner.destroy_all
	end

		def class_exists?(class_name)
      eval("defined?(#{class_name}) && #{class_name}.is_a?(Class)") == true
    end
  	context "Model Owner" do #'Owner' model and database table
    	context "Owner Model:" do
      	it "Owner class created" do
      		expect(class_exists?("Owner"))
          expect(Owner < ActiveRecord::Base).to eq(true)        
        end
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
        expect(Owner.column_names).to include "first_name", "last_name", "team_name"
        expect(Owner.column_types["first_name"].type).to eq :string
        expect(Owner.column_types["last_name"].type).to eq :string
        expect(Owner.column_types["team_name"].type).to eq :string	
        expect(Owner.column_types["created_at"].type).to eq :datetime
        expect(Owner.column_types["updated_at"].type).to eq :datetime
      end
      it "Creates a new owner" do
      	owner = Owner.create!(first_name: "Matt", last_name: "Schreiber", team_name: "Pink Unicorns")
      	expect(owner.first_name).to eq("Matt")
      	expect(owner.last_name).to eq("Schreiber")
      	expect(owner.team_name).to eq("Pink Unicorns")
      end
      it "Query by name returns correct owner" do
      	owner = Owner.create!(first_name: "Matt", last_name: "Schreiber", team_name: "Pink Unicorns")
      	owner = Owner.find_by(first_name: "Matt", last_name: "Schreiber")
      	expect(owner).to_not be_nil
      end
  	# end
  end
end
