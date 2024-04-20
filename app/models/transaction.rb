# Class represents a transaction between 2 IBANs and holds some details about the transaction
class Transaction < ApplicationRecord
  monetize :amount_cents

  enum status: %i[success in_progress failed]

  validates :iban_from, :iban_to, :status, :amount_cents, presence: true
  validates :iban_from, :iban_to,
            format: { with: /[A-Z]{2}\d{2}[A-Z]{4}\d{10}/, message: 'should be in format AA01AAAA1234567890' }
  validate :ibans_difference, on: :create
  validates :amount_cents, comparison: { greater_than: 0 }

  scope :for_iban, ->(iban) { where(iban_to: iban).or(where(iban_from: iban)) }

  private

  def ibans_difference
    return unless iban_from == iban_to

    errors.add(:iban_from, 'should differ from iban_to')
    errors.add(:iban_to, 'should differ from iban_from')
  end
end
