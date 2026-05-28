class DailyCountdownJob < ApplicationJob
  queue_as :default

  def perform
    NotificationService.send_daily_countdowns
  end
end
