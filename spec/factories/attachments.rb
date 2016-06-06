FactoryGirl.define do
  factory :attachment do
    comment
    file  { StringIO.new("hello_file.txt") }
  end
end
