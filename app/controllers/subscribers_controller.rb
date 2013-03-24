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

	def confirm
		# Subscriber clicks on email link that directs him/her to 
		# this action. Check params[:token] against token, if it
		# matches, set active boolean of the record to true,
		# display a flash notice of 'thanks your email is confirmed'
		if Subscriber.find_by_token(params[:token]).nil?
			flash[:notice] = 'Sorry your token did not match
												our records. Please re-subscribe or try
												re-clicking the Confirm link in your email'
		else
			flash[:notice] = 'Thank you! Your email address has been
												confirmed! Expect your daily email to arrive
												everyday'
    end
	end
end
