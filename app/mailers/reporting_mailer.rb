class ReportingMailer < ActionMailer::Base
  default from: "Pecunia Nunc <pecunia-nunc@tusharsaxena.com>"
  if Rails.env.production?
    @@request = "http://pecunia-nunc.herokuapp.com"
  else
    @@request = "http://pecunia-nunc.dev"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.reporting_mailer.project_errors_email.subject
  #
  def project_errors_email(errors)
    @errors = errors
    mail to: "beat.me.down@gmail.com", subject: "Errors! Fix Before Listing Sendout"
  end
end
