require 'spec_helper'

describe ApiKey, :focus => true do

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

    it "must have a unique token" do
      api_tmp = create(:api_key)
      @api_key.token = api_tmp.token
      @api_key.should_not be_valid
    end

    it "must have unique token" do
      duplicate = build(:api_key, :token => @api_key.token)
      duplicate.should_not be_valid
    end
  end

end

