require 'spec_helper'

describe SprintsController, :type => :controller do
  shared_examples("a project sprint") do
    it "assigns the current project to @project"
  end

  describe "GET #index" do
    it_behaves_like "a project sprint"
    it "populates an array of sprints"
    it "uses only sprints for the current @project"
    it "renders the :index template"
  end

  describe "GET #show" do
    it_behaves_like "a project sprint"
    it "assigns the requested sprint to @sprint"
    it "renders the :show template"
  end

  describe "GET #new" do
    it_behaves_like "a project sprint"
    it "assigns a new sprint to @sprint"
    it "renders the :new template"
  end

  describe "GET #edit" do
    it_behaves_like "a project sprint"
    it "assigns the requested sprint to @sprint"
    it "renders the :edit template"
  end

  describe "POST #create" do
    context "with valid attributes" do
      it_behaves_like "a project sprint"
      it "saves a new sprint to the database"
      it "redirects to show the sprint"
    end
    context "with invalid attributes" do
      it_behaves_like "a project sprint"
      it "does not save a new sprint in the database"
      it "re-renders the :new template"
    end
  end

  describe "POST #update" do
    context "with valid attributes" do
      it_behaves_like "a project sprint"
      it "updates a sprint to the database"
      it "redirects to show the sprint"
    end
    context "with invalid attributes" do
      it_behaves_like "a project sprint"
      it "does not update the sprint in the database"
      it "re-renders the :edit template"
    end
  end

  describe "DELETE #destroy" do
    it_behaves_like "a project sprint"
    it "deletes a sprint from the database"
    it "redirects to the sprint index"
  end
end
