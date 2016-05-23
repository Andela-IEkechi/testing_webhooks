require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:assignee) { create(:user) }

  before(:each) do
    sign_in(user)
    @request.env["CONTENT_TYPE"] = "application/json"

    @membership = create(:member, user: user)
    @project = @membership.project
    @ticket = create(:ticket, project: @project)
  end

  describe "index" do
    before(:each) do
      @params = {project_id: @project.id, ticket_id: @ticket.id}
    end

    Member::ROLES.each do |role|
      context "as #{role}" do
        it "returns 200 when authorised" do
          get :index, params: @params
          expect(response.status).to eq(200)
        end

        it "returns allowed comments" do
          5.times do
            create(:comment, ticket: @ticket, commenter: user, assignee: assignee)
            create(:comment)
          end

          get :index, params: @params
          json = JSON.parse(response.body)
          expect(json.count).to eq(5)
        end
      end
    end

    #it "fails to bring up comments if not ticket ID is provided"
    #it "fails to bring up comments if no proejct ID is provided"
    #it "fails to bring up comments if the ticket we provide does not match the project that we provide"
  end

  describe "show" do
    before(:each) do
      @comment = create(:comment, ticket: @ticket, commenter: user, assignee: assignee)
      @params = { project_id: @project.id, ticket_id: @ticket.id, id: @comment.id }
    end

    Member::ROLES.each do |role|
      context "as #{role}" do
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

        it "returns the comment" do
          get :show, params: @params
          json = JSON.parse(response.body)
          expect(json).to eq(JSON.parse(@comment.to_json))
        end
      end
    end
  end

  describe "create" do
    before(:each) do
      @comment = build(:comment)
      @params = { project_id: @project.id, ticket_id: @ticket.id, comment: attributes_for(:comment) }
    end

    #review note: restricted users should not be able to make comments.
    #test that it fails for them.
    #see roles discussion below
    Member::ROLES.each do |role|
      context "as #{role}" do
        it "returns 200 when authorised" do
          post :create, params: @params
          expect(response.status).to eq(200)
        end
      end
    end
  end

  describe "update" do
    before(:each) do
      @status = create(:status, project: @project)
      @comment = create(:comment, ticket: @ticket, commenter: user, assignee: assignee, status: @status)
      @params = { project_id: @project.id, ticket_id: @ticket.id,
                 id: @comment.id, comment: attributes_for(:comment) }
    end
    
    # review note: restricted users cannot update comments, test that it fails for them. See ticket controller spec for examples
    #see roles discussion below
    Member::ROLES.each do |role|
      context "as #{role}" do
        it "returns 200 when authorised" do
          put :update, params: @params
          expect(response.status).to eq(200)
        end

        it "returns the updated comment" do
          put :update, params: @params
          json = JSON.parse(response.body)
          @comment.reload
          expect(json).to eq(JSON.parse(@comment.attributes.to_json))
        end

        it "does not update without ticket id" do
          @params[:ticket_id] = nil
          expect { put :update, params: @params }.to raise_error(ActiveRecord::StatementInvalid)
        end

        # review note: check for project id also
        # it "does not update without project id" do
        #   @params[:project_id] = nil
        #   expect { put :update, params: @params }.to raise_error(ActiveRecord::StatementInvalid)
        # end
      end
    end
  end

  describe "delete" do
    before(:each) do
      @comment = create(:comment, ticket: @ticket, commenter: user, assignee: assignee)
      @params = { project_id: @project.id, ticket_id: @ticket.id, id: @comment.id }
    end

    # review note: again, not for restricted. Also, commenters can only delete their OWN comments (regular)
    # admins and owners can delete ANYONES comments.
    Member::ROLES.each do |role|
      context "as #{role}" do
        it "deletes the comment for a member" do
          delete :destroy, params: @params
          expect(response.status).to eq(200)
        end
      end
    end
  end
end


# review notes: roles discussion:

# owner: can do anything to anything. Can delete/update anyone's comments
# admin: same as owner
# regular: can create/update/delete thier OWN comments only
# can only view comments(index, show), cannot create/update/delete at all. 
