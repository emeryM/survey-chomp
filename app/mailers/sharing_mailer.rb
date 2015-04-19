class SharingMailer < ApplicationMailer
  default from: "survey.chomp.mailer@gmail.com"

  def share_email(participant)
    @participant = participant
    mail(to: @participant, subject: 'Test')
  end
  
end
