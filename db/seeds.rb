# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
john = User.create(
  first_name: 'John',
  last_name: 'McClane',
  email: 'john.mcclane@diehard.com',
  password: 'password',
  password_confirmation: 'password'
)

hans = User.create(
  first_name: 'Hans',
  last_name: 'Gruber',
  email: 'hans.gruber@diehard.com',
  password: 'password',
  password_confirmation: 'password'
)

[john, hans].each do |user|
  user.bank_accounts.first.deposit_in_cents(rand(10_000..20_000))
end
