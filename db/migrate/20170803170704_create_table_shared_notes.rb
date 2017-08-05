class CreateTableSharedNotes < ActiveRecord::Migration[5.0]
  def change
    create_table :shared_notes do |t|
      t.integer :user_id
      t.integer :note_id
      t.boolean :seen, default: false, null: false

      t.timestamp
    end

    add_index :shared_notes, [:user_id], name: 'index_shared_notes_on_user_id'
    add_index :shared_notes, [:note_id], name: 'index_shared_notes_on_note_id'
    add_index :shared_notes, [:seen], name: 'index_shared_notes_on_seen'
    add_index :shared_notes, [:user_id, :note_id], name: 'index_sn_on_user_id_note_id', unique: true
  end
end

# r = SharedNote.new(user_id:2, note_id:7)
# r = SharedNote.new(user_id:2, note_id:6)
