FactoryGirl.define do
  factory :task do
    sequence(:title) { |n| "Task № #{n}" }
    sequence(:description)  { |n| "Task description № #{n}" }
  end

  factory :invalid_task do
    title nil
  end

  factory :user do
    sequence(:email) { |n| "user#{n}@email.com" }
    password 'foobar123'
    password_confirmation { |u| u.password }

    factory :user_with_tasks do
      after(:build) do |user|
        user.tasks << FactoryGirl.build(:task)
      end
    end
  end
end
