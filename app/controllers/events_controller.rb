class EventsController < ApplicationController
  before_action :require_login, except: [:index, :show]
  before_action :set_event, only: [:show, :edit, :update, :destroy, :messages, :create_message]
  
  def index
    @events = if logged_in?
      current_user.hosted_events.includes(:host).order(:target_date)
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
    @event.host_id = current_user.id
    
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
  
  def messages
  end
  
  def create_message
  end
  
  def join
  end

  private
  
  def set_event
    @event = Event.find(params[:id])
  end
  
  def event_params
    params.require(:event).permit(:name, :description, :target_date, :is_surprise)
  end
end
