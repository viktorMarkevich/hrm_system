module EventsHelper

  def title_calendar
    ->(start_date) { content_tag :span, "#{I18n.t('date.month_names')[start_date.month]} #{start_date.year}", class: 'calendar-title' }
  end

  def previous_month_link
    ->(param, date_range) { link_to raw('&laquo;'), {param => date_range.first - 1.day} }
  end

  def next_month_link
    ->(param, date_range) { link_to raw('&raquo;'), {param => date_range.last + 1.day} }
  end

end
