class AddIndexesToTransactions < ActiveRecord::Migration[7.1]
  def change
    add_index :transactions, :iban_from
    add_index :transactions, :iban_to
  end
end
