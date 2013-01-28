require 'spec_helper'

describe LandingController do

  describe "GET 'home'" do
    it "returns http success" do
      get 'home'
      response.should be_success
    end
  end

  describe "GET 'tour'" do
    it "returns http success" do
      get 'tour'
      response.should be_success
    end
  end

  describe "GET 'pricing'" do
    it "returns http success" do
      get 'pricing'
      response.should be_success
    end
  end

  describe "GET 'signup'" do
    it "returns http success" do
      get 'signup'
      response.should be_success
    end
  end

end
