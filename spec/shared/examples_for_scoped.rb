shared_examples_for "scoped" do
  before(:each) do
    @instance = create(scoped_class.name.downcase.to_sym)
  end

  it "should respond to :scoped_id" do
    @instance.should respond_to(:scoped_id)
  end

  it "should respond to :to_param" do
    @instance.should respond_to(:scoped_id)
  end

  it "should have a :scoped_id as the value for :to_param" do
    @instance.scoped_id = @instance.id + 1
    @instance.scoped_id.should_not eq(@instance.id)

    #we might be using a slug
    if @instance.respond_to? :slug
      @instance.save #force the slug to update if there is one
      (@instance.to_param =~ /#{@instance.scoped_id}/).should eq(0) #starts with the scoped id
    else
      @instance.to_param.should eq(@instance.scoped_id)
    end
  end

end
