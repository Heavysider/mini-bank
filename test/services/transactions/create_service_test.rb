module Transactions
  class CreateServiceTest < ActiveSupport::TestCase
    test 'should successfully create a Transaction' do
      transfer_amount = 1
      old_transaction_count = Transaction.count
      Transactions::CreateService.new(bank_accounts(:johns).iban, bank_accounts(:hanss).iban, transfer_amount).perform
      new_transaction = Transaction.last
      assert_equal old_transaction_count + 1, Transaction.count
      assert_equal 'success', new_transaction.status
      assert_nil new_transaction.failure_reason
    end

    test 'should successfully transfer money between BankAccounts' do
      johns_ba = bank_accounts(:johns)
      hanss_ba = bank_accounts(:hanss)
      old_johns_balance = johns_ba.balance_cents
      old_hanss_balance = hanss_ba.balance_cents
      transfer_amount = 1
      Transactions::CreateService.new(johns_ba.iban, hanss_ba.iban, transfer_amount).perform
      assert_equal johns_ba.reload.balance_cents, old_johns_balance - transfer_amount * 100
      assert_equal hanss_ba.reload.balance_cents, old_hanss_balance + transfer_amount * 100
    end

    test 'should gracefully fail if IBAN is not found' do
      old_transaction_count = Transaction.count
      Transactions::CreateService.new(bank_accounts(:johns).iban, 'AA01AAAA1234567890', 1).perform
      new_transaction = Transaction.last
      assert_equal old_transaction_count + 1, Transaction.count
      assert_equal 'failed', new_transaction.status
      refute_nil new_transaction.failure_reason
    end
  end
end
