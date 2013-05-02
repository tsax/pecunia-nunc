class SubscribersController < ApplicationController

	def home
		@subscriber = Subscriber.new
	end

	def new
		require 'digest'
		@subscriber = Subscriber.new(params[:subscriber])
		@subscriber.token = Digest::SHA1.hexdigest([Time.now, rand].join)
		if @subscriber.save
			flash[:success] = "Thanks for signing-up. Please confirm your email address through the email that'll be in your inbox shortly!"

			redirect_to home_path
		else
			flash[:notice] = "There were errors! Please resubmit after making corrections."
			render 'home'
		end	
	end

	def confirm_or_unsubscribe
		@subscriber = Subscriber.find_by_token(params[:token])
		binding.pry if Rails.env.development?
		if @subscriber.nil?
			flash[:error] = 'Sorry your token did not match our records. Please re-subscribe or try re-clicking the Confirm link in your email'
		  redirect_to home_path
		elsif params[:do] == 'confirm'
			@subscriber.active = true
			@subscriber.save
			flash[:success] = 'Thank you! Your email address has been confirmed! Expect your daily email to arrive everyday'
      puts 'Confirmed'
			redirect_to home_path
	  
	  elsif params[:do] == 'unsubscribe'
	  	@subscriber.active = false
	  	@subscriber.save
	  	flash[:notice] = 'Sorry to see you go! You have been unsubscribed'
	  	puts 'Unsubscribed'
			redirect_to home_path
	  else
    	puts 'This should not happen'
	  	redirect_to home_path
	  end
	end
end
