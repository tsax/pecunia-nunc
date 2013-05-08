	
	desc "This task is called by the Heroku scheduler add-on"
	
	task :send_daily_listing => :environment do
		puts "Updating project listing..."
  # Move project listing code into a model
  # Call the model method here
  # Make sure it updates a db
  #NewsFeed.update
	  projects = Kickstarter.by_list(:ending_soon, :pages => :all)
	  projs = projects.select { |proj| proj.pledge_percent > 80.0 and proj.pledge_deadline.day == Time.now.day }
	  puts "Got the projects!"
	  Subscriber.all.each do |sub|
	  	puts "#{sub.email}\t"
	  	if sub.active
		  	if sub.last_email.nil? || sub.last_email.strftime("%F") < Time.now.strftime("%F")
		  		SubscriberMailer.daily_email(sub, projs).deliver
		  		sub.last_email = Time.now
		  		sub.save
		  		puts "#{sub.email}\tsent."  
		  	else
		  		puts "No email should be sent as it has already been sent for the day."
		  	end
		  else
		  	puts "Subscriber is not active. Send no email."
		  end
	  end
	  puts "done."
	end

	desc "This task tests out the daily email using only one subscriber 20 times"
	task :test_daily_email => :environment do
		puts "Testing daily email with first id"
		projects = Kickstarter.by_list(:ending_soon, pages: :all)
		projs = projects.select { |p| p.pledge_percent > 80.0 && p.pledge_percent < 100.0}
		puts "Got the projects"
		s = Subscriber.find_by_email('beat.me.down@gmail.com')
		20.times do 
			SubscriberMailer.daily_email(s, projs).deliver
			puts "#{s.email}\t sent."
		end
	end
	
	desc "This task cleans up all the unsubscribed users by deletion"
	task :cleanup_unsubscribers => :environment do
		Subscriber.where(:active => false).each { |s| s.destroy }
	end

	task :update_listing => :environment do
	  #User.send_reminders
	  puts "Sending daily project listing..."
	  puts "done."
	end

