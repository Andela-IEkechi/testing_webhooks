require 'spec_helper'

describe CommentsController do
  shared_examples("a ticket dependant") do
    it "assigns the current ticket to @ticket"
  end

  describe "GET #index" do
    it "should not do anything"
  end

  describe "GET #show" do
    it "should not do anything"
  end

  describe "GET #new" do
    it "should not do anything"
  end

  describe "GET #edit" do
    it "should update the comment in the database"
    it "redirects to show the parent ticket"
  end

  describe "POST #create" do
    it_behaves_like "a ticket dependant"
    context "with valid attributes" do
      it "saves a new comment to the database"
      it "redirects to show the parent ticket"
    end
    context "with invalid attributes" do
      it "does not save a new comment in the database"
      it "re-renders the parent ticket :edit template"
    end
  end

  describe "POST #update" do
    it_behaves_like "a ticket dependant"
    context "with valid attributes" do
      it "updates a comment to the database"
      it "redirects to show the comment"
    end
    context "with invalid attributes" do
      it "does not update the comment in the database"
      it "re-renders the :edit template"
    end
  end

  describe "DELETE #destroy" do
    it_behaves_like "a ticket dependant"
    it "deletes a comment from the database"
    it "redirects to the comment index"
    it "cannot be destroyed if it has tickets"
  end
end
