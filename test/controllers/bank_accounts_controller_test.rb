class BankAccountsControllerTest < ActionDispatch::IntegrationTest
  test 'should show BankAccount when signed in' do
    sign_in users(:john)

    get user_bank_account_url(users(:john), users(:john).bank_accounts.first)
    assert_response :success
  end

  test "should show BankAccount when signed in and filtered by 'all'" do
    sign_in users(:john)

    get user_bank_account_url(users(:john), users(:john).bank_accounts.first), params: { status: 'all' }
    assert_response :success
  end

  test "should show BankAccount when signed in and filtered by 'success'" do
    sign_in users(:john)

    get user_bank_account_url(users(:john), users(:john).bank_accounts.first), params: { status: 'success' }
    assert_response :success
  end

  test "should show BankAccount when signed in and filtered by 'in_progress'" do
    sign_in users(:john)

    get user_bank_account_url(users(:john), users(:john).bank_accounts.first), params: { status: 'in_progress' }
    assert_response :success
  end

  test "should show BankAccount when signed in and filtered by 'failed'" do
    sign_in users(:john)

    get user_bank_account_url(users(:john), users(:john).bank_accounts.first), params: { status: 'failed' }
    assert_response :success
  end

  test "should respond with 401 when accessing another user's page" do
    sign_in users(:hans)

    get user_bank_account_url(users(:john), users(:john).bank_accounts.first)
    assert_response :unauthorized
  end

  test 'should redirect to sign in when not signed in' do
    get user_bank_account_url(users(:john), users(:john).bank_accounts.first)
    assert_redirected_to new_user_session_path
  end
end
