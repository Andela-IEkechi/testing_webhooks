require 'rails_helper'

RSpec.describe "foos/new", type: :view do
  before(:each) do
    assign(:foo, Foo.new())
  end

  it "renders new foo form" do
    render

    assert_select "form[action=?][method=?]", foos_path, "post" do
    end
  end
end
