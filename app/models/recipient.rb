class Recipient < ApplicationRecord
    has_many :log_entries
    belongs_to :manager, class_name: "Recipient", optional: true
end
