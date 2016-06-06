FactoryGirl.define do
  factory :api_key do
    project
    name { Faker::Company.name }
    # access_key { Faker::Crypto.sha1 } #we generate the key on create
  end
end
