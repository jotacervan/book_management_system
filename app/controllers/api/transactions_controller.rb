class Api::TransactionsController < ApplicationController
  before_action :authenticate_user! 

  def index
    @transactions = Transaction.all 
    render json: {
      transactions: @transactions
    }
  end

  def show
    @transaction = Transaction.find(params[:id])
    render json: { 
      transaction: @transaction
    }
  end

  def create
    begin
      @transaction = Transaction.create!(transaction_params)
      render json: { transaction: @transaction, message: 'Transaction created successfully' }
    rescue Exception => e
      render json: { error: true, message: e.message }, status: 403
    end
  end

  def update
    @transaction = Transaction.find(params[:id])
    if @transaction.update(transaction_params)
      render json: { transaction: @transaction, message: 'Book updated successfully' }
    else
      render json: { error: true, message: 'Not able to return the book' }, status: 403
    end
  end

  def return
    @transaction = Transaction.find(params[:id])
    if @transaction.update(returned: true)
      render json: { transaction: @transaction, message: 'Book returned successfully' }
    else
      render json: { error: true, message: 'Not able to return the book' }, status: 403
    end
  end

  private
  def transaction_params
    params.require(:transaction).permit(:user_id, :book_id, :start_date, :end_date, :returned)
  end
end
