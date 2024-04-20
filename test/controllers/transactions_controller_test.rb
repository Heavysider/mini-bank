class TransactionsControllerTest < ActionDispatch::IntegrationTest
  test "should respond with 401 if current_user doesn't own the outgoing bank account" do
    john = users(:john)
    hanss_ba = bank_accounts(:hanss)
    sign_in john

    post user_bank_account_transactions_url(john, hanss_ba),
         params: {
           transaction: { iban: hanss_ba.iban, amount: 10.0 }
         },
         as: :json, xhr: true
    assert_response :unauthorized
  end
end
