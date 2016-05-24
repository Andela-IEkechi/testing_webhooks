FactoryGirl.define do
  factory :attachment do
    comment
    file Refile::FileDouble.new("dummy", "logo.png", content_type: "image/png")
  end
end
