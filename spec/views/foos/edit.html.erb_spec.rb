require 'rails_helper'

RSpec.describe "foos/edit", type: :view do
  before(:each) do
    @foo = assign(:foo, Foo.create!())
  end

  it "renders the edit foo form" do
    render

    assert_select "form[action=?][method=?]", foo_path(@foo), "post" do
    end
  end
end
