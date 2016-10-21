class BorrowersController < ApplicationController
  def create
    borrower = Borrower.new(first_name: params[:first_name], last_name: params[:last_name], email: params[:email], password: params[:password], password_confirmation: params[:password_confirmation], reason: params[:reason], description: params[:description], amount: params[:amount].to_i, raised: 0)
    if borrower.save
      session[:borrower_id] = borrower.id
      redirect_to "/lendings/borrower/#{borrower.id}"
    else
      flash[:messages] = borrower.errors.full_messages
      redirect_to '/'
    end
  end
end
