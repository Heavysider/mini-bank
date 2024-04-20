# Asynchronous processing of a transaction
class ProcessTransactionJob < ApplicationJob
  queue_as :transactions

  def perform(iban_from, iban_to, amount)
    Transactions::CreateService.new(iban_from, iban_to, amount).perform
  end
end
