require 'spec_helper'

describe TicketStatus do
  let(:subject) {create(:ticket_status)}

  it {expect(subject).to belong_to(:project)}
  it {expect(subject).to validate_presence_of(:project)}
  it {expect(subject).to validate_presence_of(:name)}
  it {expect(subject).to validate_uniqueness_of(:name).scoped_to(:project_id)}
  it {expect(subject).to respond_to(:open!)}
  it {expect(subject).to respond_to(:close!)}
  it {expect(subject).to respond_to(:sort_index)}
  it {expect(subject).to respond_to(:system_default)}

  it "has a working factory" do
    expect(subject).to_not be_nil
  end

  it "responds with it's name for to_s" do
    expect(subject.to_s).to eq(subject.name)
  end

  it "can be closed" do
    subject.open.should eq(true)
    subject.close!
    subject.open.should eq(false)
  end

  it "can be opened" do
    subject.open = false
    subject.open.should eq(false)
    subject.open!
    subject.open.should eq(true)
  end

  it "knows about comments that use it" do
    comment = create(:comment, :status => subject)
    expect(comment.status.comments.count).to eq(1)
  end

  it "should not be deleted if it is in use" do
    comment = create(:comment, :status => subject)
    status = comment.status
    expect {
      status.destroy
    }.to change(TicketStatus, :count).by(0)
    expect {
      status.comments.find_each(&:destroy)
      status.destroy
    }.to change(TicketStatus, :count).by(-1)
  end
end
