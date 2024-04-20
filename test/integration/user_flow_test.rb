require 'test_helper'

class UserFlowTest < ActionDispatch::IntegrationTest
  test 'can see the User page' do
    user = users(:john)
    sign_in user
    get user_url(user)
    assert_select 'div#account-name-iban', "Personal Account - #{user.bank_accounts.first.iban}"
  end

  test 'can see the User page' do
    user = users(:john)
    sign_in user
    get user_url(user)
    assert_select 'div#account-name-iban', "Personal Account - #{user.bank_accounts.first.iban}"
  end
end
