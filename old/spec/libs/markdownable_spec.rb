require 'spec_helper'

describe Markdownable do
  before(:all) do
    @markdown = "
#this is a heading
##this is another heading with no line inbetween

* this is
* a listing
* with 3 elements

**this is bold**

*this is italic*

_this uses emphasis_

This line contains intra_emphasis

This line...
is above this one

This line is seperated by a blank line from the ones above it

This line is followed by a double newlines


This line is preceeded by a double newline

"
  end

  context "by itself" do

    it "should respond to to_html" do
      expect(Markdownable).to respond_to(:to_html)
    end

    context "when converting to html" do
      before(:each) do
        @html = Markdownable.to_html(@markdown)
      end

      it "should convert markdown syntax into html" do
        expect(@html.include?('<h1>')).to eq(true)
      end

      it "should convert single newlines into <br>" do
        expect(@html.include?('This line...<br>is above this one')).to eq(true)
      end

      it "should not allow intra-emphasis" do
        expect(@html.include?('intra_emphasis')).to eq(true)
      end

      it "should allow normal emphasis" do
        expect(@html.include?('<em>this uses emphasis</em>')).to eq(true)
      end
    end
  end

  context "when included into another class" do
    it "should render the body value on save"
  end

end
