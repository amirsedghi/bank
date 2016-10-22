class LendingsController < ApplicationController
  before_action :require_login, except: [:index, :member, :create, :login]
  before_action :require_correct_lender, only: [:main_lender]
  before_action :require_correct_borrower, only: [:main_borrower]

  def require_login
    if session[:lender_id] == nil and session[:borrower_id] == nil
      redirect_to '/'
    end
  end

  def require_correct_lender
    if session[:lender_id] == nil
      redirect_to "/lendings/borrower/#{session[:borrower_id]}"
    else
      lender = Lender.find(session[:lender_id])
      confirm = Lender.find(params[:id])
      if lender != confirm
        redirect_to "/lendings/lender/#{session[:lender_id]}"
      end
    end
  end

  def require_correct_borrower
    if session[:borrower_id] == nil
      redirect_to "/lendings/lender/#{session[:lender_id]}"
    else
      borrower = Borrower.find(session[:borrower_id])
      confirm = Borrower.find(params[:id])
      if borrower != confirm
        redirect_to "/lendings/borrower/#{session[:borrower_id]}"
      end
    end
  end

  def index
  end

  def create
    lender = Lender.new(first_name: params[:first_name], last_name: params[:last_name], email: params[:email], password: params[:password], password_confirmation: params[:password_confirmation], money: params[:money])

    if lender.save
      session[:lender_id] = lender.id
      redirect_to "/lendings/lender/#{lender.id}"
    else
      flash[:messages] = lender.errors.full_messages
      redirect_to '/'
    end
  end

  def member
  end

  def login
    lender = Lender.find_by(email: params[:email])
    if lender == nil
      borrower = Borrower.find_by(email: params[:email])
      if borrower == nil
        flash[:messages] = ["No user found"]
        redirect_to '/lendings/member'
      else
        if borrower.authenticate(params[:password])
          session[:borrower_id] = borrower.id
          redirect_to "/lendings/borrower/#{borrower.id}"
        else
          flash[:messages] = ["No user found"]
          redirect_to '/lendings/member'
        end
      end
    else
      if lender.authenticate(params[:password])
        session[:lender_id] = lender.id
        redirect_to "/lendings/lender/#{lender.id}"
      else
        borrower = Borrower.find_by(email: params[:email])
        if borrower == nil
          flash[:messages] = ["No user found"]
          redirect_to '/lendings/member'
        else
          if borrower.authenticate(params[:password])
            session[:borrower_id] = borrower.id
            redirect_to "/lendings/borrower/#{borrower.id}"
          else
            flash[:messages] = ["No user found"]
            redirect_to '/lendings/member'
          end
        end
      end
    end

  end

  def main_lender
    @lender = Lender.find(session[:lender_id])
    @borrowers = Borrower.all
    # @lended = Transaction.joins(:lender).joins(:borrower).where(lender: @lender).select("borrowers.first_name as first_name", "borrowers.last_name as last_name", :reason, :description, "borrowers.amount as amount", "transactions.amount as t_amount", :raised, "sum(transactions.amount) as total").group("borrowers.id, transactions.amount")
    @lended = Transaction.joins(:lender).joins(:borrower).where(lender: @lender).group("borrowers.id").select("borrowers.first_name as first_name", "borrowers.last_name as last_name", :reason, :description, "borrowers.amount as amount", :raised, "sum(transactions.amount) as total")
    # @lended.group(:reason).sum("transactions.amount")
  end

  def main_borrower
    @borrower = Borrower.find(session[:borrower_id])
    @list = Transaction.joins(:lender).joins(:borrower).where(borrower: @borrower).group("lenders.id").select("lenders.first_name as first_name", "lenders.last_name as last_name", "lenders.email as email", "sum(transactions.amount) as total")
  end

  def logout
    session.destroy
    redirect_to '/'
  end

  def add
    lender = Lender.find(session[:lender_id])
    borrower = Borrower.find(params[:id])
    if lender.money >= params[:amount].to_i
      transaction = Transaction.new(lender: lender, borrower: borrower, amount: params[:amount].to_i)
      if transaction.save
        lender.money -= params[:amount].to_i
        borrower.raised += params[:amount].to_i
        borrower.save
        lender.save
        redirect_to "/lendings/lender/#{session[:lender_id]}"
      else
        flash[:message] = lender.errors.full_messages
        redirect_to "/lendings/lender/#{session[:lender_id]}"
      end
    else
      flash[:messages] = ["Insufficient funds"]
      redirect_to "/lendings/lender/#{session[:lender_id]}"
    end

  end
end
