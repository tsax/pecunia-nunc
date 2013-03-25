class SubscriberMailer < ActionMailer::Base
  default from: "pecunia-nunc@tusharsaxena.com"

  def confirmation_mail(subscriber)
  	@subscriber = subscriber
  	@url = "#{request.fullpath.split("?")[0]}"
  end
end
