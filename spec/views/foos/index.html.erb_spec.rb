require 'rails_helper'

RSpec.describe "foos/index", type: :view do
  before(:each) do
    assign(:foos, [
      Foo.create!(),
      Foo.create!()
    ])
  end

  it "renders a list of foos" do
    render
  end
end
