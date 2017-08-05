FactoryGirl.define do
  factory :note do
    title 'Some test title'
    description 'here is some big description text'
    calendar_date Time.now
  end
end
