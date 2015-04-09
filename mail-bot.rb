require 'nutella_lib'
require 'json'
require 'mandrill'
m = Mandrill::API.new 'i4frQYcTBMyZ6bYyLkEVOQ'


# Initialize nutella
nutella.init("crepe", "localhost", "mail-bot")

puts "Mail bot initialization"

nutella.net.handle_requests('mail/send', lambda do |request, component_id, resource_id|
	puts "Send mail to " + request['to'] + "message: " + request['message']

  template_name = 'Nutella subscription'
  template_content = [
      {
          "name"=> "main",
          "content"=> "Congratulation: subscription to component
                    <b>#{request['componentName']}</b>
                    has been succeded."
      }
  ]
  message = {
      :subject=> "Notification subscription success",
      :from_name=> "Nutella Monitoring Interface",
      :to=>[
          {
              :email=> request['to'],
              # :name=> ""
          }
      ],
      :from_email=>"nutellamonitoring@gmail.com"
  }

  sending = m.messages.send_template template_name, template_content, message
  puts sending


  {"status" => "ok"}
end)

puts "Initialization completed"

# Just sit there waiting for messages to come
nutella.net.listen