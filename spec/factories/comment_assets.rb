# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :comment_asset, :class => 'Comment::Asset' do
    association :comment

  end
end
