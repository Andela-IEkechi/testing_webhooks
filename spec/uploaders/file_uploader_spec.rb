require 'spec_helper'
require 'carrierwave/test/matchers'

describe FileUploader do
  include CarrierWave::Test::Matchers

  before(:each) do
    @asset = create(:comment_asset)
    filename = "#{Rails.root}/spec/data/dummy.file"
    @asset.payload = FileUploader.new
    @asset.payload.store!(File.open(filename))
  end

  after(:each) do
    @asset.payload.remove!
  end

  it "should attach a file to an asset" do
    @asset.payload.should be_present
  end

end