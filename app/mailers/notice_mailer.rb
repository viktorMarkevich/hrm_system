class NoticeMailer < ActionMailer::Base
  add_template_helper(ApplicationHelper)
  add_template_helper(UsersHelper)

  def notice_of_appointment(sticker)
    @sticker = sticker
    mail(to: @sticker.performer.email, from: @sticker.owner.email , subject: 'Notice of appointment the sticker')
  end

  def sticker_closed(sticker)
    @sticker = sticker
    mail(to: @sticker.owner.email, from: @sticker.performer.email , subject: 'Sticker completed')
  end

end