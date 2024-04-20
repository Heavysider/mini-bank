class UsersControllerTest < ActionDispatch::IntegrationTest
  test 'should show User page when signed in' do
    sign_in users(:john)

    get user_url(users(:john))
    assert_response :success
  end

  test "should respond with 401 when accessing another user's page" do
    sign_in users(:hans)

    get user_url(users(:john))
    assert_response :unauthorized
  end

  test 'should redirect to sign in when not signed in' do
    get user_url(users(:john))
    assert_redirected_to new_user_session_path
  end
end
