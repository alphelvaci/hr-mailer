require 'test_helper'

class RecipientTest < ActiveSupport::TestCase
  test 'presence validations' do
    with_nil_kolay_ik_id = recipients(:one).dup
    with_nil_kolay_ik_id.kolay_ik_id = nil
    assert_not with_nil_kolay_ik_id.save

    with_nil_first_name = recipients(:one).dup
    with_nil_first_name.first_name = nil
    assert_not with_nil_first_name.save

    with_nil_last_name = recipients(:one).dup
    with_nil_last_name.last_name = nil
    assert_not with_nil_last_name.save

    with_nil_email = recipients(:one).dup
    with_nil_email.email = nil
    assert_not with_nil_email.save

    with_nil_birth_date = recipients(:one).dup
    with_nil_birth_date.birth_date = nil
    assert_not with_nil_birth_date.save

    with_nil_employment_start_date = recipients(:one).dup
    with_nil_employment_start_date.employment_start_date = nil
    assert_not with_nil_employment_start_date.save

    with_nil_is_active = recipients(:one).dup
    with_nil_is_active.is_active = nil
    assert_not with_nil_is_active.save
  end

  test 'active scope' do
    Recipient.active.all.each do |r|
      assert r.is_active
    end
  end

  test 'get_recipients_to_celebrate method' do
    # disallowed parameters days_ahead > 28 and reason not in ['birthday', 'work_anniversary']
    assert_raises { Recipient.get_recipients_to_celebrate('birthday', 29) }
    assert_raises { Recipient.get_recipients_to_celebrate('work_anniversary', 29) }
    assert_raises { Recipient.get_recipients_to_celebrate('unknown', 29) }
    assert_raises { Recipient.get_recipients_to_celebrate('unknown', 28) }

    travel_to Date.new(2023, 12, 20) do
      assert_same 3, Recipient.get_recipients_to_celebrate('birthday', 7).length
      assert_same 2, Recipient.get_recipients_to_celebrate('work_anniversary', 7).length

      assert_same 4, Recipient.get_recipients_to_celebrate('birthday', 28).length
      assert_same 3, Recipient.get_recipients_to_celebrate('work_anniversary', 28).length

      assert_not_includes Recipient.get_recipients_to_celebrate('birthday', 28), recipients(:inactive)
      assert_not_includes Recipient.get_recipients_to_celebrate('work_anniversary', 28), recipients(:inactive)
    end
  end
end
