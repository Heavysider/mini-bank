class AddBalanceToBankAccounts < ActiveRecord::Migration[7.1]
  def change
    add_monetize :bank_accounts, :balance
  end
end
