class Lender < ActiveRecord::Base
  EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]+)\z/i
  has_secure_password
  has_many :transactions, dependent: :destroy
  has_many :borrowers, through: :transactions
  validates :first_name, :last_name, presence: true, length: { in: 2..20 }, :on => :create
  validates :money, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: EMAIL_REGEX } , :on => :create
  validates :password, presence: true, length: { in: 8..20 } , :on => :create
end
