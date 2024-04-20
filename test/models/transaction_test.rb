require 'test_helper'

class TransactionTest < ActiveSupport::TestCase
  test 'should not save Transaction without iban_from' do
    transaction = Transaction.new(iban_to: 'AA01AAAA1234567890', status: 1, amount_cents: 10_000)

    refute transaction.save, 'Saved the Transaction without iban_from'
    assert_equal transaction.errors.messages[:iban_from].first, "can't be blank"
  end

  test 'should not save Transaction incorrect iban_from' do
    transaction = Transaction.new(iban_from: 'Test', iban_to: 'AA01AAAA1234567890', status: 1, amount_cents: 10_000)

    refute transaction.save, 'Saved the Transaction with incorrect iban_from'
    assert_equal transaction.errors.messages[:iban_from].first, 'should be in format AA01AAAA1234567890'
  end

  test 'should not save Transaction without iban_to' do
    transaction = Transaction.new(iban_from: 'AA01AAAA1234567890', status: 1, amount_cents: 10_000)

    refute transaction.save, 'Saved the Transaction without iban_to'
    assert_equal transaction.errors.messages[:iban_to].first, "can't be blank"
  end

  test 'should not save Transaction incorrect iban_to' do
    transaction = Transaction.new(iban_to: 'Test', iban_from: 'AA01AAAA1234567890', status: 1, amount_cents: 10_000)

    refute transaction.save, 'Saved the Transaction with incorrect iban_to'
    assert_equal transaction.errors.messages[:iban_to].first, 'should be in format AA01AAAA1234567890'
  end

  test 'should not save Transaction without status' do
    transaction = Transaction.new(iban_from: 'AA01AAAA1234567890', iban_to: 'AA01AAAA1234567890', amount_cents: 10_000)

    refute transaction.save, 'Saved the Transaction without status'
    assert_equal transaction.errors.messages[:status].first, "can't be blank"
  end

  test 'should not save Transaction with identical iban_from and iban_to' do
    transaction = Transaction.new(iban_from: 'AA01AAAA1234567890', iban_to: 'AA01AAAA1234567890', amount_cents: 10_000,
                                  status: 1)

    refute transaction.save, 'Saved the Transaction with identical iban_from and iban_to'
    assert_equal transaction.errors.messages,
                 { iban_from: ['should differ from iban_to'], iban_to: ['should differ from iban_from'] }
  end

  test 'should save a valid Transaction' do
    transaction = Transaction.new(iban_from: 'AA01AAAA1234567890', iban_to: 'AA01AAAA1234567891', amount_cents: 10_000,
                                  status: 1)

    assert transaction.save, "Didn't save a valid Transaction"
  end

  test '.for_iban should return incoming and outgoing Transactions for an IBAN' do
    Transaction.create(iban_from: 'AA01AAAA1234567890', iban_to: 'AA01AAAA1234567891', amount_cents: 10_000,
                       status: 1)
    Transaction.create(iban_from: 'AA01AAAA1234567891', iban_to: 'AA01AAAA1234567890', amount_cents: 10_000,
                       status: 1)
    Transaction.create(iban_from: 'AA01AAAA1234567891', iban_to: 'AA01AAAA1234567892', amount_cents: 10_000,
                       status: 1)
    assert_equal Transaction.for_iban('AA01AAAA1234567890').count, 2,
                 "Didn't return incoming and outgoing Transactions for an IBAN"
  end
end
