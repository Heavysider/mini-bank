module Transactions
  # Contains logic of creating a transaction
  class CreateService
    # @param iban_from [String] IBAN to get the money from
    # @param iban_to [String] IBAN to deliver the money to
    # @param amount [String | Integer | Float] Amount of money to deliver - format "123.45"
    def initialize(iban_from, iban_to, amount)
      @iban_from = iban_from
      @iban_to = iban_to
      @amount_cents = amount.to_f * 100
    end

    attr_reader :amount_cents, :iban_to, :iban_from

    def perform
      transaction = prepare_transaction
      perform_transaction(transaction)
    end

    private

    def prepare_transaction
      Transaction.create(
        iban_from:,
        iban_to:,
        amount_cents:,
        status: Transaction.statuses[:in_progress]
      )
    end

    def perform_transaction(transaction)
      ActiveRecord::Base.transaction do
        BankAccount.find_by!(iban: iban_from).withdrawal_in_cents(amount_cents)
        BankAccount.find_by!(iban: iban_to).deposit_in_cents(amount_cents)
        transaction.success!
      end
    rescue ActiveRecord::RecordNotFound
      transaction.update!(failure_reason: 'Unknown IBAN', status: Transaction.statuses[:failed])
    rescue ActiveRecord::RecordInvalid => e
      transaction.update!(failure_reason: e.message, status: Transaction.statuses[:failed])
    rescue StandardError
      transaction.update!(failure_reason: 'Unknown reason', status: Transaction.statuses[:failed])
    end
  end
end
