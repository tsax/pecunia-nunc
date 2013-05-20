	
	desc "Task: Send the daily digest"
	
	task :send_daily_listing => :environment do
		puts "Updating project listing..."

		projects = Kickstarter.by_list(:ending_soon, pages: :all).select {|p| p.pledge_deadline.strftime("%F") < (Time.now + 3*24*60*60).strftime("%F") && p.pledge_percent > 79.9}
	  unfunded, funded = projects.partition { |p| p.pledge_percent < 100.0 }
	  funded = funded.sort { |p1, p2| [p2.pledge_percent] <=> [p1.pledge_percent] }[0..4]

	  puts "Got the projects!"
	  Subscriber.all.each do |sub|
	  	puts "#{sub.email}\t"
	  	if sub.active
		  	if sub.last_email.nil? || sub.last_email.strftime("%F") < Time.now.strftime("%F")
		  		SubscriberMailer.daily_email_bifurcated(sub, unfunded, funded).deliver
		  		sub.last_email = Time.now
		  		sub.save
		  		puts "#{sub.email}\tsent."  
		  	else
		  		puts "Subscriber #{sub.email} No email should be sent as it has already been sent for the day."
		  	end
		  else
		  	puts "Subscriber #{sub.email} is not active. Send no email."
		  end
	  end
	  puts "Emails sent."
	end

	desc "This task tests out the daily email using only one subscriber 20 times"
	task :test_daily_email => :environment do
		puts "Testing daily email with first id"
		
		projects = Kickstarter.by_list(:ending_soon, pages: :all).select {|p| p.pledge_deadline.strftime("%F") < (Time.now + 3*24*60*60).strftime("%F") && p.pledge_percent > 79.9}
	  unfunded, funded = projects.partition { |p| p.pledge_percent < 100.0 }
	  funded = funded.sort { |p1, p2| [p2.pledge_percent] <=> [p1.pledge_percent] }[0..4]
		
		puts "Got the projects"
		s = Subscriber.find_by_email('beat.me.down@gmail.com')
		5.times do 
			SubscriberMailer.daily_email_bifurcated(s, unfunded, funded).deliver
			puts "#{s.email}\t sent."
		end
	end
	
	desc "This task tests email using 3 random projects"
	task :test_five_projects => :environment do
		projects = Kickstarter.by_list(:ending_soon, :pages => 1)[0..4].sort_by { |p| p.pledge_percent }
		puts "Retrieved 3 random projects."
		s = Subscriber.find_by_email('beat.me.down@gmail.com')

		SubscriberMailer.daily_email(s, projects).deliver
		puts "#{s.email}\t sent."
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

