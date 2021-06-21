class Api::UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    render json: { message: 'test' }
  end

  def show
    @user = User.find(params[:id])
    render json: { 
      user: @user.as_json(only: [:name, :email, :balance, :account_number]),
      current_books: @user.transactions&.active&.as_json
    }
  end
end
