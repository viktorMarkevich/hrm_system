class NoticeMailer < ActionMailer::Base
  add_template_helper(ApplicationHelper)
  add_template_helper(UsersHelper)

  def event_soon(event, user)
    @event = event
    @user = user
    mail(to: user.email, from: event.staff_relation.candidate.owner.email, subject: 'Event soon')
  end
end