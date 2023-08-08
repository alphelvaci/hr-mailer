# README

This application sends emails to Pisano employees on their birthdays and
Employment anniversaries.

Currently, there is only a development environment. To setup:

1. Get the master encryption key (only required for pulling real data from KolayIK)
2. `rails console`
3. Inside the console: `Recipient.refresh_all` and `CelebrationEvent.generate_future_celebration_events`
4. `rails server`
5. Go to: http://127.0.0.1:3000/celebration-events
