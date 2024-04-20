class RemoveDateFromTransactions < ActiveRecord::Migration[7.1]
  def change
    remove_column :transactions, :date
  end
end
