class SubscribersController < ApplicationController

	def home
		@subscriber = Subscriber.new
	end

	def new
		require 'digest'
		@subscriber = Subscriber.new(params[:subscriber])
		@subscriber.token = Digest::SHA1.hexdigest([Time.now, rand].join)
		if @subscriber.save
			flash[:notice] = "Thanks for signing-up. Please confirm your email address through the email that'll be in your inbox shortly!"

			redirect_to home_path
		else
			flash[:notice] = "There were errors! Please resubmit after making corrections."
			redirect_to home_path
		end	
	end

	def confirm_or_unsubscribe
		@subscriber = Subscriber.find_by_token(params[:token])
		if @subscriber.nil?
			flash[:notice] = 'Sorry your token did not match
												our records. Please re-subscribe or try
												re-clicking the Confirm link in your email'
		elsif params[:action] = 'confirm'
			@subscriber.active = true
			@subscriber.save
			flash[:notice] = 'Thank you! Your email address has been
												confirmed! Expect your daily email to arrive
												everyday'
	  elsif params[:action] = 'unsubscribe'
	  	@subscriber.active = false
	  	@subscriber.save
	  	flash[:notice] = 'Sorry to see you go! You have been unsubscribed'
	  end
	end
end
