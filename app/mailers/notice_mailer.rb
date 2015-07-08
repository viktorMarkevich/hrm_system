class NoticeMailer < ActionMailer::Base

  def notice_of_appointment(sticker)
    @sticker = sticker
    mail(to: @sticker.performer.email, from: @sticker.owner.email , subject: 'Notice of Appointment')
  end

end