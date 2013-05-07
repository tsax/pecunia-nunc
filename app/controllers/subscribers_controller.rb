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
			SubscriberMailer.confirmation_email(@subscriber).deliver
			redirect_to home_path
		else
			flash[:notice] = "There were errors! Please resubmit after making corrections."
			render 'home'
		end	
	end

	def confirm
		puts "confirm pre-action"
		@subscriber = Subscriber.find_by_token(params[:token])
		unless @subscriber.nil?
			@subscriber.active = true
			if @subscriber.save
				puts "YEEHAWW"
				flash[:success] = 'Thank you! Your email address has been confirmed! Expect your daily email to arrive everyday'
	      puts 'Confirmed'
				render 'home'
	  	else
	  		puts 'This should not happen. Could not save subscriber.'
	  	end
	  else
	  	puts "SORRY TO SEE YOU GO!"
			flash[:error] = 'Sorry your token did not match our records. Please re-subscribe or try re-clicking the Confirm link in your email'
		  redirect_to home_path
	  end
	end

	def unsubscribe
		@subscriber = Subscriber.find_by_token(params[:token])
		unless @subscriber.nil?
			@subscriber.active = false
	  	@subscriber.save
	  	flash[:notice] = "Sorry to see you go! You have been unsubscribed. You'll be able to re-subscribe after a week."
	  	puts 'Unsubscribed'
			redirect_to home_path
			# render 'home'
		else
			puts 'This should not happen'
		end
	end
end
