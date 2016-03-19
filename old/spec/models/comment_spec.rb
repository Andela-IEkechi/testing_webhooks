require 'spec_helper'

describe Comment do
  let(:subject) { create(:comment) }

  it {expect(subject).to respond_to(:created_at)}
  it {expect(subject).to respond_to(:updated_at)}
  it {expect(subject).to validate_presence_of(:status_id)}
  it {expect(subject).to validate_inclusion_of(:cost).in_array(Ticket::COST)}

  context "has a factory that"  do
    it "creates a valid comment" do
      comment = create(:comment)
      comment.should_not be_nil
      comment.should be_valid
    end

    it "creates a valid comment with a body" do
      comment = create(:comment_with_body)
      comment.should_not be_nil
      comment.should be_valid
      comment.body.should_not be_blank
    end

    it "creates a comment with a sprint only" do
      comment = create(:comment_with_sprint)
      comment.sprint_id.should_not be_nil
    end
  end

  context "validates that" do
    it "should have a default cost of 0" do
      subject.cost.should == 0
    end

    it "must have either an api_key or user_id, but not both" do
      subject.user_id.should_not be_nil
      subject.should be_valid

      subject.user_id = nil
      subject.should_not be_valid

      subject.api_key = create(:api_key)
      subject.should be_valid
    end
  end

  context 'contains body markup that' do
    before(:each) do
      subject = build(:comment, :status => create(:ticket_status))
    end

    it 'can be plain text' do
      subject.body = "plain text"
      subject.should be_valid
    end

    it 'can be markdown flavoured text' do
      subject.body = "#markdown text"
      subject.should be_valid
    end

    it 'stores the parsed markdown' do
      subject.body = "#markdown text"
      subject.rendered_body.should be_blank
      subject.save
      subject.rendered_body.should_not be_blank
    end

    it 'has markdown text which is converted to HTML ' do
      subject.body = "# markdown text #"
      subject.save
      subject.rendered_body.should eq('<h1>markdown text</h1>')
    end
  end

  it "is deleted when it's parent ticket is destroyed" do
    comment = create(:comment)
    expect {
      comment.ticket.destroy
    }.to change(Comment, :count).by(-1)
  end
end
