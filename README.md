# README

This application sends emails to Pisano employees on their birthdays and
Employment anniversaries.

Currently, there is only a development environment. To setup:

1. Get the master encryption key. (required for pulling real data from KolayIK)
2. Set up local postgresql server.
3. Run `rails db:setup`.
4. Run `rails console`.
5. Inside the console run: `Recipient.refresh_all` and `CelebrationEvent.generate_future_celebration_events`.
6. Inside the console create and save a single `Admin` record.
7. Run: `rails server`.
8. Go to: http://127.0.0.1:3000/celebration-events, and login.

Notes for Pisano team to create a production environment:

1. Configure a database, I used and tested with postgresql.
2. See the steps for the development environment to populate the database for the first time. After that, everything will be on a schedule.
3. The single `Admin` record you create must have the email `people@pisano.com`.
4. Configure Ruby Action Mailer to use Pisano SMTP, ideally with a new email such as celebrations@pisano.com.
5. Set the `default from` in `application_mailer.rb` to the preferred email.
6. I used the whenever gem to schedule jobs. Please update the crontab with `whenever --update-crontab`.
7. Verify the crontab with `crontab -l`, it should have four entries from this app.
8. Hopefully all should work!
