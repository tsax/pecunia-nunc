class SubscriberMailer < ActionMailer::Base
  default from: "pecunia-nunc@tusharsaxena.com"

  def confirmation_mail(subscriber)
  	@subscriber = subscriber
  	@url = "#{request.fullpath.split("?")[0]}?do=confirm&&token=#{@subscriber.token}"
  	mail to: @subscriber.email, subject: "Welcome to Pecunia Nunc. Please confirm this address"
  end

  def daily_email(subscriber, projects)
  	@subscriber = subscriber
  	@projects = projects
  	@url = "#{request.fullpath.split("?")[0]}?do=unsubscribe&&token=#{@subscriber.token}"
  	mail to: @subscriber.email, subject: "Kickstarters Ending Today"
  end
end
