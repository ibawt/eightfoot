FactoryGirl.define do
  factory :user do |user|
    user.email { "foo@bar.com" }
    user.password { "thisisapassword" }
  end

  factory :project do |p|
    name "Test Project"

    factory :project_with_repositories do
      ignore do
        repository_count 5
      end

      after(:create) do |project, evaluator|
        project.repositories << FactoryGirl.create(:repository)
      end
    end
  end

  factory :repository do |r|
    slug "ibawt/eightfoot"
  end
end
