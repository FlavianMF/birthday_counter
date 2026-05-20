class RegistrationsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    user = User.new(registration_params)
    
    if user.save
      session[:user_id] = user.id
      redirect_to events_path, notice: 'Conta criada com sucesso! Bem-vindo!'
    else
      flash.now[:alert] = user.errors.full_messages.join(', ')
      render :new, status: :unprocessable_entity
    end
  end
  
  private
  
  def registration_params
    params.permit(:email, :password, :password_confirmation, :name)
  end
end
