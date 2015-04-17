require 'nutella_lib'
require 'json'
require 'mandrill'
m = Mandrill::API.new 'i4frQYcTBMyZ6bYyLkEVOQ'



# Parse command line arguments
broker, app_id, run_id = nutella.parse_args ARGV
# Extract the component_id
component_id = nutella.extract_component_id
# Initialize nutella
nutella.init(broker, app_id, run_id, component_id)

puts "Mail bot initialization"

nutella.net.handle_requests('mail/send_subscription', lambda do |request, from|
  object = request['application']

  if request['instance'] != nil
    object = object + ' > ' + request['instance']
    if request['component'] != nil
      object = object + ' > ' + request['component']
    end
  end

	puts "Send mail to " + request['to'] + "message: " + object


  template_name = 'Nutella subscription'
  template_content = [
      {
          :name=> 'main',
          :content=> "Congratulation: subscription to component
                    <b>#{object}</b>
                    has been succeded."
      }
  ]
  message = {
      :subject=> "Subscription to #{object}",
      :from_name=> 'Nutella Monitoring Interface',
      :to=>[
          {
              :email=> request['to'],
              # :name=> ""
          }
      ],
      :from_email=>'nutellamonitoring@gmail.com'
  }

  sending = m.messages.send_template template_name, template_content, message
  puts sending


  {:status => 'ok'}
end)

nutella.net.handle_requests('mail/send_notification', lambda do |request, from|
  object = request['application']

  if request['instance'] != nil
    object = object + ' > ' + request['instance']
    if request['component'] != nil
      object = object + ' > ' + request['component']
    end
  end

  puts "Send mail to " + request['to'] + "message: " + object

  template_name = 'Nutella alert'
  template_content = [
      {
          :name=> 'main',
          :content=> "Attention: component
                      <b>#{object}</b>
                      had a problem and went down."
      }
  ]
  message = {
      :subject=> "Alert: #{object} went down",
      :from_name=> 'Nutella Monitoring Interface',
      :to=>[
          {
              :email=> request['to'],
              # :name=> ""
          }
      ],
      :from_email=>'nutellamonitoring@gmail.com'
  }

  sending = m.messages.send_template template_name, template_content, message
  puts sending


  {:status => 'ok'}
end)

puts "Initialization completed"

# Just sit there waiting for messages to come
nutella.net.listen