class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email])
    
    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to events_path, notice: 'Bem-vindo de volta!'
    else
      flash.now[:alert] = 'Email ou senha inválidos'
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: 'Até logo!'
  end
end
