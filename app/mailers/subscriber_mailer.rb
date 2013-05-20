class SubscriberMailer < ActionMailer::Base
  default from: "Pecunia Nunc <pecunia-nunc@tusharsaxena.com>"
  if Rails.env.production?
    @@request = "http://pecunia-nunc.herokuapp.com"
  else
    @@request = "http://pecunia-nunc.dev"
  end
  
  def confirmation_email(subscriber)
  	@subscriber = subscriber
  	@url = "#{@@request}/confirm?token=#{@subscriber.token}"
  	# @url = "#{request.fullpath.split("?")[0]}?do=confirm&&token=#{@subscriber.token}"
  	mail to: @subscriber.email, subject: "Welcome to Pecunia Nunc. Please confirm this address"
  end

  def daily_email(subscriber, projects)
  	@subscriber = subscriber
  	@projects = projects
  	@url = "#{@@request}/unsubscribe?token=#{@subscriber.token}"
  	# @url = "#{request.fullpath.split("?")[0]}?do=unsubscribe&&token=#{@subscriber.token}"
  	mail to: @subscriber.email, subject: "Hi #{@subscriber.name.titleize}! Kickstarters Ending Today"
  end

  def daily_email_bifurcated(subscriber, unfunded, funded)
    @subscriber = subscriber
    @unfunded = unfunded
    @funded = funded
    @url = "#{@@request}/unsubscribe?token=#{@subscriber.token}"
    # @url = "#{request.fullpath.split("?")[0]}?do=unsubscribe&&token=#{@subscriber.token}"
    mail to: @subscriber.email, subject: "Hi #{@subscriber.name.titleize}! Kickstarters Ending Today"
  end

end
