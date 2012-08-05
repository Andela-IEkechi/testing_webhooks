require 'spec_helper'

describe TicketsController do

  shared_examples("access to tickets") do
    describe "GET #index" do
      it "populates an array of tickets"
      it "uses only tickets for the current @project"
      it "renders the :index template"
    end

    describe "GET #show" do
      it "redirect to the :edit action"
    end

    describe "GET #new" do
      it "assigns a new ticket to @ticket"
      it "renders the :new template"
    end

    describe "GET #edit" do
      it "assigns the requested ticket to @ticket"
      it "renders the :edit template"
    end

    describe "POST #create" do
      context "with valid attributes" do
        it "saves a new ticket to the database"
        it "redirects to show the ticket"
      end
      context "with invalid attributes" do
        it "does not save a new ticket in the database"
        it "re-renders the :new template"
      end
    end

    describe "POST #update" do
      context "with valid attributes" do
        it "updates a ticket to the database"
        it "redirects to show the ticket"
      end
      context "with invalid attributes" do
        it "does not update the ticket in the database"
        it "re-renders the :edit template"
      end
    end

    describe "DELETE #destroy" do
      it "deletes a ticket from the database"
      it "redirects to the ticket index"
      it "also deletes related comments"
    end
  end

  context "when it belongs to a feature" do
    it "assigns the current feature to @feature"
    it "assigns the current parent to @ticketable"
    it_behaves_like "access to tickets"
  end

  context "when belongs to a project" do
    it "assigns the current project to @project"
    it "assigns the current parent to @ticketable"
    it_behaves_like "access to tickets"
  end

end