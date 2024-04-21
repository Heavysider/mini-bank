# Class represents a User of our Digi Bank
class User < ApplicationRecord
  devise :database_authenticatable, :rememberable, :validatable, :trackable

  has_many :bank_accounts

  validates :first_name, :last_name, :email, presence: true
  validates :password_confirmation, presence: true, if: :password_required?

  after_create :create_bank_account

  def avatar
    "https://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(email)}"
  end

  private

  def create_bank_account
    bank_accounts.create(name: 'Personal account')
  end
end
