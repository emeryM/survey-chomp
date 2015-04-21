require 'csv'

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

  protect_from_forgery with: :exception
  def can_administer?
    true
  end

  helper_method :send_share_mail

  def send_share_mail
    @survey_owner = params[:survey_owner]
    @survey_link = "http://hidden-ridge-9675.herokuapp.com/surveys/question_groups/" + params[:survey_link] + "/answer_groups/new"
    #@participants = params[:participants].split(',')
    @participants = "test@gmail.com, morgan.a.emery@gmail.com, memery@ufl.edu".split(',')
    SharingMailer.share_email(@participants, @survey_owner, @survey_link).deliver_now
    redirect_to "/surveys"
  end

  @question_groups = Rapidfire::QuestionGroup.all
end
