shared_examples_for "scoped" do
  it "should respond to :scoped_id", focus: true
  it "should respond to :to_param", focus: true
  it "should report :scoped_id as the value for :to_param", focus: true
end
