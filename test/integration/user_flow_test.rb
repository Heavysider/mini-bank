require 'test_helper'

class UserFlowTest < ActionDispatch::IntegrationTest
  test 'can login' do
    user = users(:john)
    get new_user_session_url
    post user_session_url(user: { email: user.email, password: 'Yippee-ki-yay' })
    assert_redirected_to user_url(user)
  end

  test "can't login with incorrect credentials" do
    user = users(:john)
    get new_user_session_url
    post user_session_url(user: { email: user.email, password: 'Yippee-ki-yay mthfcka' })
    assert_response 422, @response.body.to_s
    assert_select 'div.alert-danger', 'Invalid Email or password.'
  end

  test 'can see the User page' do
    user = users(:john)
    sign_in user
    get user_url(user)
    assert_select 'div#account-name-iban', "Personal Account - #{user.bank_accounts.first.iban}"
  end

  test 'can send a payment' do
    user = users(:john)
    sign_in user
    get user_url(user)
    assert_select 'form#payment'
    post user_bank_account_transactions_url(user, user.bank_accounts.first),
         params: {
           transaction: { iban: users(:hans).bank_accounts.first.iban, amount: 10.0 }
         },
         as: :json, xhr: true
    assert_response :success
    assert_equal 'Transaction initiated', JSON.parse(@response.body)['message']
  end
end
