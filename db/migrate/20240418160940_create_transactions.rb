class CreateTransactions < ActiveRecord::Migration[7.1]
  def change
    create_table :transactions do |t|
      t.string :iban_from
      t.text :iban_to
      t.integer :status
      t.datetime :date

      t.timestamps
    end
  end
end
