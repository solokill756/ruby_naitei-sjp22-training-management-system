FactoryBot.define do
  factory :user_task do
    association :user
    association :task
    association :user_subject
    status { :not_done }
    spent_time { Faker::Number.between(
      from: Settings.user_task.min_spent_time + 1,
      to: Settings.user_task.min_spent_time + 100
    ) } 

    # Trait cho trạng thái done
    trait :done do
      status { :done }
    end

    # Trait cho spent_time không hợp lệ
    trait :invalid_spent_time do
      spent_time { Faker::Number.between(
        from: Settings.user_task.min_spent_time - 10,
        to: Settings.user_task.min_spent_time - 1
      ) }
    end

    # Trait setup user là supervisor
    trait :with_supervisor do
      association :user, factory: [:user, :supervisor]
    end

    # Trait để thêm tài liệu đính kèm
    trait :with_documents do
      after(:build) do |user_task|
        user_task.documents.attach(
          io: StringIO.new(Faker::Lorem.paragraph),
          filename: Faker::File.file_name(dir: "documents", ext: "pdf"), 
          content_type: "application/pdf"
        )
      end
    end

    trait :with_invalid_documents do
      after(:build) do |user_task|
        user_task.documents.attach(
          io: StringIO.new(Faker::Lorem.paragraph), 
          filename: Faker::File.file_name(dir: "documents", ext: "exe"), 
          content_type: "application/x-msdownload"
        )
      end
    end

    trait :with_large_documents do
      after(:build) do |user_task|
        user_task.documents.attach(
          io: StringIO.new("a" * (Settings.user_task.max_document_size.megabytes + 1)),
          filename: "test.pdf",
          content_type: "application/pdf"
        )
      end
    end

    trait :with_max_size_documents do
      after(:build) do |user_task|
        user_task.documents.attach(
          io: StringIO.new("asdasdasdasd" * Settings.user_task.max_document_size.megabytes),
          filename: "test.pdf",
          content_type: "application/pdf"
        )
      end
    end

    trait :with_less_size_documents do
      after(:build) do |user_task|
        user_task.documents.attach(
          io: StringIO.new("asadasdasasd" * (Settings.user_task.min_document_size.megabytes - 1)),
          filename: "test.pdf",
          content_type: "application/pdf"
        )
      end
    end
  end
end
