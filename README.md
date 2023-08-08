# README

This application sends emails to Pisano employees on their birthdays and
Employment anniversaries.

Currently, there is only a development environment. To setup:

1. Get the master encryption key (only required for pulling real data from KolayIK)
2. `rails db:setup`
3. `rails console`
4. Inside the console: `Recipient.refresh_all` and `CelebrationEvent.generate_future_celebration_events`
5. `rails server`
6. Go to: http://127.0.0.1:3000/celebration-events
