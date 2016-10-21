class Borrower < ActiveRecord::Base
  EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]+)\z/i
  has_secure_password
  has_many :transactions, dependent: :destroy
  has_many :lenders, through: :transactions
  validates :first_name, :last_name, :reason, presence: true, length: { in: 2..20 } , :on => :create
  validates :description, presence: true , :on => :create
  validates :amount, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: EMAIL_REGEX } , :on => :create
  validates :password, presence: true, length: { in: 8..20 }, :on => :create
end
