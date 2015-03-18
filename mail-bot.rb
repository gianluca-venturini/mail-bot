require 'nutella_lib'
require 'json'


# Initialize nutella
nutella.init("crepe", "localhost", "mail-bot")

puts "Mail bot initialization"

nutella.net.handle_requests('mail/send', lambda do |request, component_id, resource_id|
	puts "Send mail to " + request['to'] + "message: " + request['message']

	{"status" => "ok"}
end)

puts "Initialization completed"

# Just sit there waiting for messages to come
nutella.net.listen
