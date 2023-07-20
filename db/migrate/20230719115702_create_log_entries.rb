class CreateLogEntries < ActiveRecord::Migration[7.0]
  def change
    create_table :log_entries do |t|
      t.string :status, null: false
      t.datetime :sent_at
      t.text :error_message

      t.belongs_to :recipient, index: true, foreign_key: true, null: false
      t.belongs_to :cc_recipient, foreign_key: { to_table: :recipients }

      t.timestamps
    end
  end
end
