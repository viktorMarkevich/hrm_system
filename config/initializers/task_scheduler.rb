scheduler = Rufus::Scheduler.new

scheduler.cron '00 00 * * *' do
  Event.events_soon_mailer
end