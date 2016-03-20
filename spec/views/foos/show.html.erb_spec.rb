require 'rails_helper'

RSpec.describe "foos/show", type: :view do
  before(:each) do
    @foo = assign(:foo, Foo.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
