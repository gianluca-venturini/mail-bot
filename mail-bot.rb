require 'nutella_lib'
require 'json'



# Parse command line arguments
broker, app_id, run_id = nutella.parse_args ARGV
# Extract the component_id
component_id = nutella.extract_component_id
# Initialize nutella
nutella.init(broker, app_id, run_id, component_id)

puts "Mail bot initialization"

nutella.net.handle_requests('mail/send', lambda do |request, from|
	puts "Send mail to " + request['to'] + "message: " + request['message']

	{"status" => "ok"}
end)

puts "Initialization completed"

# Just sit there waiting for messages to come
nutella.net.listen
