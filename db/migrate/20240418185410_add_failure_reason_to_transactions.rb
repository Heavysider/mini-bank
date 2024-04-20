class AddFailureReasonToTransactions < ActiveRecord::Migration[7.1]
  def change
    add_column :transactions, :failure_reason, :string
  end
end
