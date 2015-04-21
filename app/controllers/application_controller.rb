require 'csv'

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

  protect_from_forgery
  def can_administer?
    true
  end

  helper_method :send_share_mail

  def send_share_mail
    @survey_owner = params[:survey_owner]
    @survey_link = "http://hidden-ridge-9675.herokuapp.com/surveys/question_groups/" + params[:survey_link] + "/answer_groups/new"
    @participants = params[:participants].gsub(/\s+/, "").split(',')
    @send_list = []
    @fail_list = []
    @participants.each do |participant|
      if participant =~ /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
        @send_list.push(participant)
      else
        @fail_list.push(participant)
      end
    end
    SharingMailer.share_email(@send_list, @survey_owner, @survey_link).deliver_now
    puts "Sent to:"
    puts @send_list
    puts "Invalid:"
    puts @fail_list
    @send_success = true
    @send_fail = false
    redirect_to "/surveys"
  end


  @question_groups = Rapidfire::QuestionGroup.all
end
