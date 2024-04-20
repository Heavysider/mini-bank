# Class represents a bank account of a user
class BankAccount < ApplicationRecord
  monetize :balance_cents

  belongs_to :user

  validates :name, :iban, :balance_cents, presence: true
  validates :iban, uniqueness: true
  validate :forbid_changing_iban, on: :update
  validates :balance_cents, comparison: { greater_than_or_equal_to: 0 }

  before_validation :set_iban

  def transactions
    Transaction.for_iban(iban).order(created_at: :desc)
  end

  def deposit_in_cents(cents)
    self.balance_cents += cents
    save!
  end

  def withdrawal_in_cents(cents)
    self.balance_cents -= cents
    save!
  end

  private

  def set_iban
    return if iban.present?

    self.iban = "NL01DIGI#{format('%010d', rand(10**10))}"
  end

  def forbid_changing_iban
    errors.add(:iban, "can't change iban") if iban_changed?
  end
end
