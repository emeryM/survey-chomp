class SharingMailer < ApplicationMailer
  default from: "survey.chomp.mailer@gmail.com"

  def share_email(participants, survey_owner, survey_link)
    @participants = participants
    @survey_owner = survey_owner
    @survey_link = survey_link
    mail(to: "survey.chomp.mailer@gmail.com", bcc: @participants, subject: 'Please participate in this SurveyChomp survey')
  end

end
