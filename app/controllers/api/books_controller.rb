class Api::BooksController < ApplicationController
  before_action :authenticate_user!

  def index
    @books = Book.all
    render json: { books: @books }
  end

  def show
    @user = User.find(params[:id])
    render json: { 
      user: @user.as_json(only: [:name, :email, :balance, :account_number])
    }
  end
end
