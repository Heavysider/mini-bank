class TransactionsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_user
  before_action :set_bank_account

  def create
    ProcessTransactionJob.perform_later(@bank_account.iban,
                                        transaction_params[:iban],
                                        transaction_params[:amount])
    respond_to do |format|
      format.json { render(json: { message: 'Transaction initiated' }, status: :ok) }
    end
  end

  private

  def set_bank_account
    @bank_account = current_user.bank_accounts.find(params[:bank_account_id])
  end

  def transaction_params
    params.require(:transaction).permit(:iban, :amount)
  end

  def authorize_user
    unless current_user.bank_accounts.where(id: params[:bank_account_id]).blank? ||
           params[:user_id].to_i != current_user.id
      return
    end

    render json: { error: 'Not Authorized' }, status: :unauthorized
  end
end
