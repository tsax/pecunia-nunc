class SubscriberMailer < ActionMailer::Base
  default from: "pecunia-nunc@tusharsaxena.com"
  @@request = "http://localhost:3000"

  def confirmation_mail(subscriber)
  	@subscriber = subscriber
  	@url = "#{@@request}?do=confirm&&token=#{@subscriber.token}"
  	# @url = "#{request.fullpath.split("?")[0]}?do=confirm&&token=#{@subscriber.token}"
  	mail to: @subscriber.email, subject: "Welcome to Pecunia Nunc. Please confirm this address"
  end

  def daily_email(subscriber, projects)
  	@subscriber = subscriber
  	@projects = projects
  	@url = "#{@@request}?do=unsubscribe&&token=#{@subscriber.token}"
  	# @url = "#{request.fullpath.split("?")[0]}?do=unsubscribe&&token=#{@subscriber.token}"
  	mail to: @subscriber.email, subject: "Kickstarters Ending Today"
  end
end
