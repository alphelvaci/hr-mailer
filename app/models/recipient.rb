class Recipient < ApplicationRecord
    has_many :log_entries
    belongs_to :manager, class_name: "Recipient", optional: true

    validates :kolay_ik_id, presence: true
    validates :first_name, presence: true
    validates :last_name, presence: true
    validates :email, presence: true
    validates :birth_date, presence: true
    validates :employment_start_date, presence: true
    validates :is_active, presence: true
end
