require 'rufus-scheduler'
s = Rufus::Scheduler.singleton
s.every '10s' do
  Rails.logger.info "Helo #{Time.now}"
  @events_soon = Event.where(will_begin_at: (Time.zone.now+1.day)..(Time.zone.now + 2.day))
  if @events_soon.count > 0
    @events_soon.each do |event|
      if  event.staff_relation && event.staff_relation.candidate && event.staff_relation.candidate.owner
        owner = event.staff_relation.candidate.owner
        NoticeMailer.event_soon(event, owner).deliver_now
      end
      if  event.staff_relation && event.staff_relation.candidate && event.staff_relation.candidate.owner
        candidate = event.staff_relation.candidate
        NoticeMailer.event_soon(event, candidate).deliver_now
      end
      if  event.staff_relation && event.staff_relation.candidate && event.staff_relation.candidate.owner && User.where(post: 'Директор').first
        ceo = User.where(post: 'Директор').first
        NoticeMailer.event_soon(event, ceo).deliver_now
      end
    end
  end
end