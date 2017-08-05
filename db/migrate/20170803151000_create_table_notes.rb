class CreateTableNotes < ActiveRecord::Migration[5.0]
  def change
    create_table :notes do |t|
      t.string :title
      t.text :description
      t.date :calendar_date
      t.belongs_to :user, index: true

      t.timestamp
    end
  end
end
