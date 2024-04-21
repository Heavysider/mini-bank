
# Digi Bank App

## Overview

Simple online banking app that includes these features:
1) Creating users via Rails console
2) Updating their balance via `deposit_in_cents` and `withdrawal_in_cents`  found on a `BankAccount` model. Example: `User.first.bank_accounts.first.deposit_in_cents(100)`
3) Users can login to see the: 
	- balance of their bank account
	- transactions and their statuses 
4) Users can transfer money between each other's accounts

## Startup instructions

The simplest way:
1) `docker pull heavysider/bank-app`
2) `docker run --rm -it -p 3000:3000 heavysider/bank-app`
3) `docker exec -it <your docker container id found via 'docker ps' command> ./bin/rails c` - to connect to Rails console and play around with data

The longer way of course would be to install required versions of `ruby`, `yarn` and install all of the dependencies. All of the exact versions needed can be found in `Dockerfile`

## Technologies used

- `sqlite` as a database, was used to simplify the docker setup. In production has to be changed to Postgres or MySQL
- `activejob` was used to perform asynchronous processing of the transactions to ensure high potential throughput. I've used the default in-memory adapter for the prototyping purposes because of ease of setup, I would probably use Sidekiq + Redis on an actual project
- `minitest` - covered main functionality with unit and integration tests, coverage report can be found in `coverage/index.html`

## Notes

Initially database is populated with 2 users:

1) Mister `John McClane` with credentials: `john.mcclane@diehard.com`, `password`
2) Mister `Hans Gruber` with credentials: `hans.gruber@diehard.com`, `password`

Both of them have Bank accounts with randomized balance between 100 and 200 Euros

In order to check the 'transferring money' functionality just check `BankAccount.all` in rails console and check IBANs. Then you can enter those IBANs in the form on the website, alongside with the amount you wish to transfer.

Also, the fact that the Transaction can still be created even if the amount entered would lower the balance into the negative is left there intentionally. This serves to show that if the Transaction fails, thanks to `ActiveRecord::Base.transaction`, the actual transfer will not be completed, and the Transaction will be rolled back. Of course a better way would be to notify user in the UI that they can't perform a transaction due to low balance and not to initiate a transaction :)
