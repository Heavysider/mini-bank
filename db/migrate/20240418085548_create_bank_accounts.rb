class CreateBankAccounts < ActiveRecord::Migration[7.1]
  def change
    create_table :bank_accounts do |t|
      t.string :name
      t.string :iban
      t.integer :user_id

      t.timestamps
    end

    add_foreign_key :bank_accounts, :users, column: :user_id
  end
end
