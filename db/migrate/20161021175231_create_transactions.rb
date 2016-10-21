class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.references :lender, index: true
      t.references :borrower, index: true
      t.integer :amount

      t.timestamps null: false
    end
    add_foreign_key :transactions, :lenders
    add_foreign_key :transactions, :borrowers
  end
end
