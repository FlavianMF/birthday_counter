class RegistrationsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(registration_params)
    
    if @user.save
      session[:user_id] = @user.id
      if session[:pending_invitation_token].present?
        event = Event.find_by(invitation_token: session[:pending_invitation_token])
        if event
          event.claim_by!(@user)
          session.delete(:pending_invitation_token)
          redirect_to event_path(event), notice: 'Surpresa! Seu aniversário foi reivindicado!'
          return
        end
      end
      redirect_to events_path, notice: 'Conta criada com sucesso! Bem-vindo!'
    else
      flash.now[:alert] = @user.errors.full_messages.join(', ')
      render :new, status: :unprocessable_entity
    end
  end
  
  private
  
  def registration_params
    params.require(:user).permit(:email, :password, :password_confirmation, :name)
  end
end
