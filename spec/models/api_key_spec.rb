# == Schema Information
#
# Table name: api_keys
#
#  name       :string(255)      not null, primary key
#  token      :string(255)      not null
#  project_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe ApiKey do

  context "has a factory that"  do
    it "should create a valid api_key" do
      api_key = create(:api_key)
      api_key.should_not be_nil
      api_key.should be_valid
    end
  end

  context "validates that it" do
    before(:each) do
      @api_key = create(:api_key)
    end

    it "must have a name" do
      @api_key.name = nil
      @api_key.should_not be_valid
    end

    it "must have a name of at least 5 characters" do
      @api_key.name = "shrt"
      @api_key.should_not be_valid
    end

    it "must have unique token" do
      duplicate = build(:api_key, :token => @api_key.token)
      duplicate.should_not be_valid
    end
  end

  it "should generate a new token with :generate_token" do
    no_token = build(:api_key)
    no_token.token.should be_blank
    no_token.generate_token
    no_token.token.should_not be_blank
    no_token.should be_valid
  end

end

