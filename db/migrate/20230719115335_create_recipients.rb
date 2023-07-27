class CreateRecipients < ActiveRecord::Migration[7.0]
  def change
    create_table :recipients do |t|
      t.string :kolay_ik_id, index: true, unique: true, null: false

      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :email, null: false

      t.date :birth_date, null: false
      t.date :employment_start_date, null: false

      t.boolean :is_active, null: false

      t.belongs_to :manager, index: true, foreign_key: { to_table: :recipients }

      t.timestamps
    end
  end
end
