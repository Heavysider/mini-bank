require 'test_helper'

class BankAccountTest < ActiveSupport::TestCase
  def setup
    super
    @user = users(:john)
  end

  test 'should not save BankAccount without name' do
    bank_account = @user.bank_accounts.new

    refute bank_account.save, 'Saved the BankAccount without name'
    assert_equal bank_account.errors.messages, { name: ["can't be blank"] }
  end

  test 'should not save BankAccount with duplicate IBAN' do
    bank_account = @user.bank_accounts.new(name: 'Test', iban: @user.bank_accounts.first.iban)

    refute bank_account.save, 'Saved the BankAccount with duplicate IBAN'
    assert_equal bank_account.errors.messages, { iban: ['has already been taken'] }
  end

  test "should not update BankAccount's IBAN" do
    bank_account = @user.bank_accounts.first
    bank_account.iban = 'NL01AAAA1234567890'

    refute bank_account.save, "Updated the BankAccount's IBAN"
    assert_equal bank_account.errors.messages, { iban: ["can't change iban"] }
  end

  test "should not update BankAccount's balance_cents to a negative value" do
    bank_account = @user.bank_accounts.first
    bank_account.balance_cents = -1

    refute bank_account.save, "Updated the BankAccount's balance to a negative value"
    assert_equal bank_account.errors.messages, { balance_cents: ['must be greater than or equal to 0'] }
  end

  test 'should create a valid BankAccount' do
    bank_account = @user.bank_accounts.create(name: 'New incrediable account')

    assert bank_account.save, "Couldn't create a valid BankAccount"
    assert_equal @user.bank_accounts.count, 2
  end

  test ".deposit_in_cents should update BankAccount's balance" do
    amount = 10_000
    bank_account = @user.bank_accounts.first
    bank_account.deposit_in_cents(amount)
    assert_equal bank_account.balance_cents, amount
  end

  test ".withdrawal_in_cents should update BankAccount's balance" do
    amount = 10_000
    bank_account = @user.bank_accounts.first
    bank_account.deposit_in_cents(amount)
    bank_account.withdrawal_in_cents(amount)
    assert_equal bank_account.balance_cents, 0
  end

  test '.withdrawal_in_cents should not leave negative balance' do
    amount = 10_000
    bank_account = @user.bank_accounts.first
    bank_account.deposit_in_cents(amount)
    assert_raises(ActiveRecord::RecordInvalid, ".withdrawal_in_cents should've raised an exception") do
      bank_account.withdrawal_in_cents(amount + 1)
    end
  end
end
