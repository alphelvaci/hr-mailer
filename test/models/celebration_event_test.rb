require 'test_helper'

class CelebrationEventTest < ActiveSupport::TestCase
  test 'default values' do
    assert celebration_events(:one).pending?
  end

  test 'celebrate method' do
    celebration_events(:one).celebrate
    assert_same 1, CelebrationMailer.deliveries.length
    assert_same 1, CelebrationMailer.deliveries[0].to.length
    assert_nil CelebrationMailer.deliveries[0].cc
    assert_match recipients(:one).email, CelebrationMailer.deliveries[0].to[0]
    assert_match 'Birthday', CelebrationMailer.deliveries[0].subject
    assert celebration_events(:one).sent?

    celebration_events(:two).celebrate
    assert_same 2, CelebrationMailer.deliveries.length
    assert_same 1, CelebrationMailer.deliveries[1].to.length
    assert_same 1, CelebrationMailer.deliveries[1].cc.length
    assert_match recipients(:two).email, CelebrationMailer.deliveries[1].to[0]
    assert_match recipients(:two).manager.email, CelebrationMailer.deliveries[1].cc[0]
    assert_match 'Anniversary', CelebrationMailer.deliveries[1].subject
    assert celebration_events(:two).sent?

    celebration_events(:three).celebrate(retry_: true)
    assert_same 3, CelebrationMailer.deliveries.length
    assert_same 1, CelebrationMailer.deliveries[2].to.length
    assert_same 1, CelebrationMailer.deliveries[2].cc.length
    assert_match recipients(:two).email, CelebrationMailer.deliveries[2].to[0]
    assert_match recipients(:two).manager.email, CelebrationMailer.deliveries[2].cc[0]
    assert_match 'Birthday', CelebrationMailer.deliveries[2].subject
    assert celebration_events(:three).sent?
    assert_nil celebration_events(:three).error_message

    celebration_events(:four).celebrate(retry_: true)
    assert_same 4, CelebrationMailer.deliveries.length
    assert_same 1, CelebrationMailer.deliveries[3].to.length
    assert_nil CelebrationMailer.deliveries[3].cc
    assert_match recipients(:one).email, CelebrationMailer.deliveries[3].to[0]
    assert_match 'Anniversary', CelebrationMailer.deliveries[3].subject
    assert celebration_events(:four).sent?
    assert_nil celebration_events(:four).error_message
  end
end
