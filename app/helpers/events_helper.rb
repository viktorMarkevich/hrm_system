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
        td_class = ['day'],["wday-#{current_calendar_date.wday.to_s}"],['td-primary'] if event.will_begin_at.to_date == current_calendar_date
      end
      { class: td_class.join(' ') }
    }
  end

  def set_events_list_title(events, date = nil)
    if date && events.blank?
      "Список предстоящих событий за #{set_month(date)} пуст"
    elsif events.present?
      "Список предстоящих событий за #{set_month(events.first.will_begin_at)}"
    else
      'Список предстоящих событий пуст'
    end

  end

  def set_month(date)
    Event::MONTHS[date.month - 1]
  end

  def get_sr_name(sr)
    "#{sr.vacancy.try(:name) + ' | Кандидат: ' + sr.candidate.name + ' | ' + sr.status}"
  end

  def set_label_class(event)
    case event.name
      when 'Утвержден'
        'label-success'
      when 'Собеседование'
        'label-info'
      else
        'label-default'
    end
  end

end
