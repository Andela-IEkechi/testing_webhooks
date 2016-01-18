shared_examples_for "scoped" do
  let(:subject) {create(scoped_class.name.downcase.to_sym)}

  it {expect(subject).to respond_to(:scoped_id)}
  it {expect(subject).to respond_to(:to_param)}

  it "scoped_id equals to_param" do
    subject.scoped_id = subject.id + 1
    expect(subject.scoped_id).to_not eq(subject.id)

    #we might be using a slug
    if subject.respond_to? :slug
      subject.save #force the slug to update if there is one
      (subject.to_param =~ /#{subject.scoped_id}/).should eq(0) #starts with the scoped id
    else
      expect(subject.to_param).to eq(subject.scoped_id)
    end
  end

end
