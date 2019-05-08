
class DelAgendaMailer < ApplicationMailer

    default from: 'from@example.com'

    def del_agenda_mail(agenda_title,send_to_members)

      @email = send_to_members.map(&:email).join(",")

      @agenda_title = agenda_title

      mail to: @email, subject: 'アジェンダ削除'
    end

end
