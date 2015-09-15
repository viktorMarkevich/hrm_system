module EventsHelper
  def default_td_classes(events)
    ->(start_date, current_calendar_date) {
      today = Time.zone.now.to_date
      td_class = ['day']
      td_class << 'today'  if today == current_calendar_date
      td_class << 'past'   if today > current_calendar_date
      td_class << 'future' if today < current_calendar_date
      td_class << 'start-date'    if current_calendar_date.to_date == start_date.to_date
      td_class << 'prev-month'    if start_date.month != current_calendar_date.month && current_calendar_date < start_date
      td_class << 'next-month'    if start_date.month != current_calendar_date.month && current_calendar_date > start_date
      td_class << 'current-month' if start_date.month == current_calendar_date.month
      td_class << "wday-#{current_calendar_date.wday.to_s}"
      events.each do |event|
        td_class = ['day'],["wday-#{current_calendar_date.wday.to_s}"],['td-primary'] if event.starts_at.to_date == current_calendar_date
      end
      { class: td_class.join(' ') }
    }
  end

  def set_month(date)
    date.present? ? date[5,6].to_i-1 : DateTime.now.month.to_i-1
  end

  def get_sr_name(sr)
    "#{sr.vacancy.try(:name) + ' | Кандидат: ' + sr.candidate.name + ' | ' + sr.status}"
  end

end
