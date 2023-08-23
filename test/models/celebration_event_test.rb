require 'test_helper'

class CelebrationEventTest < ActiveSupport::TestCase
  test 'default values' do
    assert celebration_events(:one).pending?
  end

