# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :comment_asset, :class => 'Comment::Asset' do
    association :comment

    factory :comment_asset_with_no_comment do
      comment nil
    end
  end
end
