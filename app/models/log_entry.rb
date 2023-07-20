class LogEntry < ApplicationRecord
    belongs_to :recipient
    belongs_to :cc_recipient, class_name: "Recipient", optional: true
end
