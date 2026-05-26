class InvitationsController < ApplicationController
  before_action :set_event_by_token, only: [:show, :claim]

  def show
    # Exibe landing page da surpresa (público)
    if @event.host_id.present?
      redirect_to @event, notice: "Este aniversário já foi reivindicado."
    end
  end

  def claim
    if logged_in?
      if @event.claim_by!(current_user)
        redirect_to @event, notice: "Surpresa! Agora você é o host do seu aniversário."
      else
        redirect_to invite_path(params[:token]), alert: "Não foi possível reivindicar o evento."
      end
    else
      session[:pending_invitation_token] = params[:token]
      redirect_to register_path, notice: "Faça login ou cadastre-se para reivindicar seu aniversário!"
    end
  end

  private

  def set_event_by_token
    @event = Event.find_by!(invitation_token: params[:token])
  end
end
