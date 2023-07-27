class CreateLogEntries < ActiveRecord::Migration[7.0]
  def change
    create_table :log_entries do |t|
      t.string :reason, null: false
      t.date :date, null: false

      t.string :status, null: false
      t.datetime :sent_at
      t.text :error_message

      t.belongs_to :recipient, index: true, foreign_key: true, null: false
      t.belongs_to :cc_recipient, foreign_key: { to_table: :recipients }

      t.timestamps
    end
    add_index :log_entries, [:recipient_id, :reason, :date], unique: true
  end
end
