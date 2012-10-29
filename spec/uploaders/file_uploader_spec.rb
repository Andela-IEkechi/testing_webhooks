require 'carrierwave/test/matchers'

describe FileUploader, focus: true do
  include CarrierWave::Test::Matchers

  before do
    @asset = create(:comment_asset)
    filename = "#{Rails.root}/spec/data/dummy.file"
    @asset.file = FileUploader.new(@asset, :file)
    @asset.file.store!(File.open(filename))
  end

  after do
    @asset.file.remove!
  end

  it "should attach a file to an asset" do
    @asset.file = @asset.file
    @asset.file.should be_present
  end

end