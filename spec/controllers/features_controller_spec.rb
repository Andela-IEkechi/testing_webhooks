require 'spec_helper'

describe FeaturesController do
  shared_examples("a project feature") do
    it "assigns the current project to @project"
  end

  describe "GET #index" do
    it_behaves_like "a project feature"
    it "populates an array of features"
    it "uses only features for the current @project"
    it "renders the :index template"
  end

  describe "GET #show" do
    it_behaves_like "a project feature"
    it "assigns the requested feature to @feature"
    it "renders the :show template"
  end

  describe "GET #new" do
    it_behaves_like "a project feature"
    it "assigns a new feature to @feature"
    it "renders the :new template"
  end

  describe "GET #edit" do
    it_behaves_like "a project feature"
    it "assigns the requested feature to @feature"
    it "renders the :edit template"
  end

  describe "POST #create" do
    context "with valid attributes" do
      it_behaves_like "a project feature"
      it "saves a new feature to the database"
      it "redirects to show the feature"
    end
    context "with invalid attributes" do
      it_behaves_like "a project feature"
      it "does not save a new feature in the database"
      it "re-renders the :new template"
    end
  end

  describe "POST #update" do
    context "with valid attributes" do
      it_behaves_like "a project feature"
      it "updates a feature to the database"
      it "redirects to show the feature"
    end
    context "with invalid attributes" do
      it_behaves_like "a project feature"
      it "does not update the feature in the database"
      it "re-renders the :edit template"
    end
  end

  describe "DELETE #destroy" do
    it_behaves_like "a project feature"
    it "deletes a feature from the database"
    it "redirects to show the project"
    it "cannot be destroyed if it has tickets"
  end
end
