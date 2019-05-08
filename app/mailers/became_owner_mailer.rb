class BecameOwnerMailer < ApplicationMailer
  default from: 'from@example.com'

  def became_owner_mail(team_name,owner_email_before,email)
    @email = email
    @owner_email_before = owner_email_before
    @team_name = team_name
    mail to: @email, subject: 'リーダー任命の報告'
  end
end
