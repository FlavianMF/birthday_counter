class PagesController < ApplicationController
  def home
    @events = Event.includes(:host).where(status: 'active').order(:target_date).limit(5) if logged_in?
  end
end
