class SubscribersController < ApplicationController

	def home
	end
	
	def new
		@subscriber = Subscriber.new(params[:subscriber])
		if @subscriber.save
			flash[:notice] = "Thanks for signing-up. Please confirm your email address through the email that'll be in your inbox shortly!"
			redirect_to home_path
		else
			flash[:notice] = "There were errors! Please resubmit after making corrections."
		end	
	end
end
