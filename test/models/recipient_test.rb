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
end
