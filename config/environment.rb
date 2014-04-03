# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
AuthenticationFromScratch::Application.initialize!

ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.perform_deliveries = true

ActionMailer::Base.smtp_settings = {
  :address              => "smtp.gmail.com",
  :port                 => "587",
  :domain               => "gmail.com",
  :user_name            => ENV["USERNAME"],
  :password             => ENV["PASSWORD"],
  :authentication       => "plain",
  :enable_starttls_auto => true  
}