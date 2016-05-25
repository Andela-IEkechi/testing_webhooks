FactoryGirl.define do
  factory :attachment do
    comment
    file  { File.new(File.join(Rails.root, 'spec', 'support', 'peace_essay.zip')) }
  end
end
