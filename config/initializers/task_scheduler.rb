# require 'rufus-scheduler'
# s = Rufus::Scheduler.new
# s.every '1h' do
#   Rails.logger.info "Helo #{Time.now}"
#   Event.events_soon_mailer
# end