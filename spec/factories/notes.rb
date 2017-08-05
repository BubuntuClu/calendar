FactoryGirl.define do
  factory :note do
    title 'Some test title'
    description 'here is some big description text'
    calendar_date Time.now
  end

  factory :date_note, class: "Note" do
    title 'Title for 08.08'
    description 'Description for 08.08'
    calendar_date '08.08.2017'
  end
end
