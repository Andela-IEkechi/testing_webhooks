require 'spec_helper'

describe LandingController, :type => :controller do

  describe "GET 'home'" do
    it "returns http success" do
      get 'home'
      expect(response).to have_http_status 200
    end
  end

  describe "GET 'tour'" do
    it "returns http success" do
      get 'tour'
      expect(response).to have_http_status 200
    end
  end

  describe "GET 'pricing'" do
    it "returns http success" do
      get 'pricing'
      expect(response).to have_http_status 200
    end
  end

  describe "GET 'support'" do
    it "returns http success" do
      get 'support'
      expect(response).to have_http_status 200
    end
  end

  describe "GET 'privacy'" do
    it "returns http success" do
      get 'privacy'
      expect(response).to have_http_status 200
    end
  end

  describe "GET 'terms'" do
    it "returns http success" do
      get 'terms'
      expect(response).to have_http_status 200
    end
  end

end
