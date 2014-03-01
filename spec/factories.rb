FactoryGirl.define do
  factory :user do |user|
    user.email { "foo@bar.com" }
    user.password { "thisisapassword" }
  end

  factory :project do |p|
    p.name { "Test Project" }
  end
end
