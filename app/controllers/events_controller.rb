class EventsController < ApplicationController
  before_action :require_login, except: [:index, :show]
  before_action :set_event, only: [:show, :edit, :update, :destroy, :messages, :create_message]
  
  def index
    @events = if logged_in?
      Event.where(host_id: current_user.id)
           .or(Event.where(sponsor_id: current_user.id))
           .includes(:host, :sponsor)
           .order(:target_date)
    else
      Event.includes(:host).where(status: 'active').order(:target_date).limit(5)
    end
  end

  def show
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)
    
    if @event.is_surprise?
      @event.sponsor_id = current_user.id
      # host_id will be nil initially for surprise events
    else
      @event.host_id = current_user.id
    end
    
    if @event.save
      redirect_to @event, notice: 'Evento criado com sucesso!'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @event.update(event_params)
      redirect_to @event, notice: 'Evento atualizado com sucesso!'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @event.destroy
    redirect_to events_path, notice: 'Evento removido com sucesso!'
  end
  
  def search
  end

  def find_by_code
    @event = Event.find_by(access_code: params[:access_code]&.upcase)
    
    if @event
      redirect_to join_event_path(@event)
    else
      flash.now[:alert] = "Código de acesso inválido"
      render :search, status: :not_found
    end
  end

  def join
    if @event.participants.include?(current_user)
      redirect_to @event, notice: "Você já está participando deste evento"
    end
  end

  def process_join
    if @event.participants.include?(current_user)
      redirect_to @event
    elsif @event.event_participants.create(user: current_user, role: 'guest', has_accepted: true)
      redirect_to @event, notice: "Bem-vindo ao evento!"
    else
      render :join, status: :unprocessable_entity
    end
  end

  def invite
    email = params[:email]
    if email.present? && email.match?(URI::MailTo::EMAIL_REGEXP)
      NotificationService.invite_guest(email, @event, current_user)
      redirect_to @event, notice: "Convite enviado para #{email}!"
    else
      redirect_to @event, alert: "Email inválido"
    end
  end
  
  def messages
  end
  
  def create_message
  end

  private
  
  def set_event
    @event = Event.find(params[:id])
  end
  
  def event_params
    params.require(:event).permit(:name, :description, :target_date, :is_surprise, :recipient_email).tap do |whitelisted|
      if params[:event][:game_config].present?
        whitelisted[:game_config] = params[:event][:game_config].permit!.to_h
      end
    end
  end
end
