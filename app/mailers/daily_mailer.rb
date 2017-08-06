class DailyMailer < ApplicationMailer

  def digest(user)
    @notes = user.notes.today
    @others_notes = user.others_notes.today
    mail(to: user.email, subject: 'Вопросы созданные сегодня')
  end
end
