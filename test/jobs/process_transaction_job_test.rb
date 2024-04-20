require 'test_helper'

class ProcessTransactionJobTest < ActiveJob::TestCase
  test 'account is charged' do
    old_transaction_count = Transaction.count
    perform_enqueued_jobs do
      ProcessTransactionJob.perform_later(bank_accounts(:johns).iban, bank_accounts(:hanss).iban, 100)
    end
    assert_equal old_transaction_count + 1, Transaction.count
  end
end
