class AddAmountToTransactions < ActiveRecord::Migration[7.1]
  def change
    add_monetize :transactions, :amount
  end
end
