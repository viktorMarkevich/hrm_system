class NoticeMailer < ActionMailer::Base
  add_template_helper(ApplicationHelper)
  add_template_helper(UsersHelper)

  def event_soon(events)
    @events_soon = events
    @events_soon.each do |event|
      @event = event
    a= mail(to: event.first.staff_relation.candidate.owner.email, from: event.first.staff_relation.candidate.owner.email, subject: 'Event soon1')
    b = mail(to: event.first.staff_relation.candidate.email, from: event.first.staff_relation.candidate.owner.email, subject: 'Event soon2')
    c = mail(to: User.where(post: 'Директор').first.email, from: event.first.staff_relation.candidate.owner.email, subject: 'Event soon3')
  end
  end
end