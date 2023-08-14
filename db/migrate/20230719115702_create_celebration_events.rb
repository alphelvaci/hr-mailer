class CreateCelebrationEvents < ActiveRecord::Migration[7.0]
  def change
    create_enum :celebration_event_reason, %w[birthday work_anniversary]
    create_enum :celebration_event_status, %w[pending pending_retry error sent]
    create_table :celebration_events do |t|
      t.enum :reason, enum_type: 'celebration_event_reason', null: false
      t.date :date, null: false

      t.enum :status, enum_type: 'celebration_event_status', default: 'pending', null: false
      t.datetime :sent_at
      t.text :error_message

      t.belongs_to :recipient, index: true, foreign_key: true, null: false
      t.belongs_to :cc_recipient, foreign_key: { to_table: :recipients }

      t.timestamps
    end
    add_index :celebration_events, %i[recipient_id reason date], unique: true
  end
end
