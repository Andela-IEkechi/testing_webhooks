require 'spec_helper'

describe CommentsController, focus: true do
  describe "GET #index" do
    it "does nothing"
  end

  describe "GET #show" do
    it "does nothing"
  end

  describe "GET #new" do
    it "does nothing"
  end

  describe "GET #edit" do
    it "renders the :edit template"
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "saves a new comment to the database"
      context "for project administrators"
        it "overrides the current sprint and feature"
      end
      context "for regular users"
        it "does not override the current sprint and feature"
      end
      it "redirects to show the comment's ticket"
    end
    context "with invalid attributes" do
      it "does not save a new comment in the database"
      it "re-renders the :edit template"
    end
  end

  describe "POST #update" do
    context "with valid attributes" do
      it "updates a comment in the database"
      context "for project administrators"
        it "overrides the current sprint and feature"
      end
      context "for regular users"
        it "does not override the current sprint and feature"
      end
      it "redirects to show the comment's ticket"
    end
    context "with invalid attributes" do
      it "does not update the comment in the database"
      it "re-renders the :edit template"
    end
  end

  describe "DELETE #destroy" do
    it "deletes a comment from the database"
    it "redirects to show the ticket"
  end
end
