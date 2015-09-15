class NoticeMailer < ActionMailer::Base
  add_template_helper(ApplicationHelper)
  add_template_helper(UsersHelper)

  def event_soon(events)
    @events_soon = events
    mail(to: @events_soon.first.owner.email, from: @events_soon.first.owner.email, subject: 'Event soon')
  end
end