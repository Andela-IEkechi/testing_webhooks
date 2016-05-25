require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:user) { create(:user) }

  before do
    sign_in(user)
    @request.env["CONTENT_TYPE"] = "application/json"

    @project = create(:project)
    @ticket = create(:ticket, project: @project)
    @comment = create(:comment, ticket_id: @ticket.id, commenter: user)
  end

  describe "index" do
    before(:each) do
      create(:attachment, comment: @comment)
      @params = { project_id: @project.id,
                  ticket_id: @ticket.id, comment_id: @comment.id }
    end

    Member::ROLES.each do |role|
      context "as #{role}" do
        before(:each) do
          @project.memberships.clear
          @membership = create(:member, user: user, project: @project, role: role)
        end

        it "returns 200 when authorised" do
          get :index, params: @params
          expect(response.status).to eq(200)
        end

        it "returns allowed attachments" do
          get :index, params: @params
          json = JSON.parse(response.body)
          expect(json.count).to eq(@comment.attachments.count)
        end

        it "fails to bring up attachments if comment ID is not provided" do
          @params[:comment_id] = nil
          expect{ get :index, params: @params }.to raise_error(ActionController::UrlGenerationError)
        end

      end
    end
  end

  describe "show" do
    before(:each) do
      @attachment = create(:attachment, comment: @comment)
      @params = { project_id: @project.id, ticket_id: @ticket.id,
                  comment_id: @comment.id, id: @attachment.id}
    end

    Member::ROLES.each do |role|
      context "as #{role}" do
        before(:each) do
          @project.memberships.clear
          @membership = create(:member, user: user, project: @project, role: role)
        end

        it "returns 200 when authorised" do
          get :show, params: @params
          expect(response.status).to eq(200)
        end

        it "returns 404 when not found" do
          @params[:id] = "invalid"
          get :show, params: @params
          expect(response.status).to eq(404)
        end

        it "can be found by it's id" do
          get :show, params: @params
          expect(response.status).to eq(200)
        end

        it "returns the attachment" do
          get :show, params: @params
          json = JSON.parse(response.body)
          expect(json).to eq(JSON.parse(@attachment.to_json))
        end
      end
    end
  end

  describe "attach_file_to_comment" do
    before(:each) do
      @params = { project_id: @project.id, ticket_id: @ticket.id, comment_id: @comment.id,
                  file: File.new(File.join(Rails.root, 'spec', 'support', 'peace_essay.zip')) }
    end

    (Member::ROLES - ["restricted"]).each do |role|
      context "as #{role}" do
        before(:each) do
          @project.memberships.clear
          @membership = create(:member, user: user, project: @project, role: role)
        end

        it "returns 200 when authorised" do
          get :attach_file_to_comment, params: @params
          expect(response.status).to eq(200)
        end

        it "uploads the attached file" do
          get :attach_file_to_comment, params: @params
          expect(@comment.attachments.count).to eq(1)
        end
      end
    end

    ["restricted"].each do |role|
      context "as #{role}" do
        before(:each) do
          @project.memberships.clear
          @membership = create(:member, user: user, project: @project, role: role)
        end

        it "returns 302 when unauthorised" do
          get :attach_file_to_comment, params: @params
          expect(response.status).to eq(302)
        end
      end
    end

  end

  describe "remove_file_from_comment" do
    before(:each) do
      @params = { project_id: @project.id, ticket_id: @ticket.id, comment_id: @comment.id,
                  file: File.new(File.join(Rails.root, 'spec', 'support', 'peace_essay.zip')) }
    end

    (Member::ROLES - ["restricted", "regular"]).each do |role|
      context "as #{role}" do
        before(:each) do
          @project.memberships.clear
          @membership = create(:member, user: user, project: @project, role: role)
        end

        it "returns 200 when authorised" do
          get :remove_file_from_comment, params: @params
          expect(response.status).to eq(200)
        end

        it "no file is attached to the comment" do
          get :remove_file_from_comment, params: @params
          json = JSON.parse(response.body)
          a = @comment.attachments.find(json['id'])
          expect(a['file_id']).to be_nil
        end
      end
    end

    ["regular"].each do |role|
      context "as #{role}" do
        before(:each) do
          @project.memberships.clear
          @membership = create(:member, user: user, project: @project, role: role)
        end

        it "returns 200 when the user is the commenter" do
          get :remove_file_from_comment, params: @params
          expect(response.status).to eq(200)
        end

        it "returns 302 when not the commenter" do
          @comment.commenter = create(:user)
          @comment.save
          get :remove_file_from_comment, params: @params
          expect(response.status).to eq(302)
        end
      end
    end

    ["restricted"].each do |role|
      context "as #{role}" do
        before(:each) do
          @project.memberships.clear
          @membership = create(:member, user: user, project: @project, role: role)
        end

        it "returns 302 when unauthorised" do
          get :remove_file_from_comment, params: @params
          expect(response.status).to eq(302)
        end
      end
    end
  end

end