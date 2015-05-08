require 'spec_helper'

describe Asset, :focus do
  let(:subject) {create(:asset)}

  it {expect(subject).to respond_to(:created_at)}
  it {expect(subject).to respond_to(:updated_at)}
  it {expect(subject).to respond_to(:feature)}
  it {expect(subject).to respond_to(:sprint)}
  it {expect(subject).to respond_to(:comment)}
  it {expect(subject).to belong_to(:project)}
  it {expect(subject).to validate_presence_of(:project)}
  it {expect(subject).to respond_to(:payload_size)}
  it {expect(subject).to respond_to(:verify_payload!)}

  it "has a working factory" do
    expect(subject).to_not be_nil
  end

  context "with uploaded files" do
    it "can attach a file" do
      filename = "#{Rails.root}/spec/data/dummy.file"
      subject.payload = FileUploader.new(subject, :file)
      subject.payload.store!(File.open(filename))
      expect(subject.payload.file).to_not be_nil
    end
  end

  describe '.payload_size' do
    it "is zero by default" do
      tmp = Asset.new
      expect(tmp.payload_size).to be_zero
    end
  end

  describe '.verify_payload!' do
    it "sets payload_exists" do
      subject.payload_size = 99
      subject.save!

      expect {
        subject.verify_payload!
      }.to change{subject.updated_at}
    end
  end

end
