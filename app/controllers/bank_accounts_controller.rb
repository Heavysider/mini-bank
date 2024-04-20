class BankAccountsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_user
  before_action :set_bank_account

  def show
    @transactions = case params[:status]
                    when 'all'
                      @bank_account.transactions
                    when 'success', 'in_progress', 'failed'
                      @bank_account.transactions.send params[:status]
                    else
                      @bank_account.transactions.success
                    end
  end

  private

  def set_bank_account
    @bank_account = current_user.bank_accounts.find(params[:id])
  end

  def authorize_user
    return unless current_user.bank_accounts.where(id: params[:id]).blank? || params[:user_id].to_i != current_user.id

    render file: 'public/401.html', status: :unauthorized
  end
end
