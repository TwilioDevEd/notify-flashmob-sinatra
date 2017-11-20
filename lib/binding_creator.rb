module BindingCreator
  def self.create_binding(binding_type, address, tag, identity)
    account_sid = ENV['TWILIO_ACCOUNT_SID']
    auth_token = ENV['TWILIO_AUTH_TOKEN']

    client = Twilio::REST::Client.new(account_sid, auth_token)

    service = client.notify.v1.services(ENV['TWILIO_NOTIFY_SERVICE'])

    # Set a random identity (if you have a model representing participants, 
    # their UUID is a good substitute here -- this is random for illustration 
    # purposes only, as this sample code does not have a User model)
    if identity.nil?
      identity = ('a'..'z').to_a.shuffle[0,8].join
    end

    # Format phone number type addresses with country code (for this sample, 
    # we'll use US only) and remove punctuation
    if binding_type == 'sms' && address[0..1] != "+1"
      address = "+1#{address.gsub(/[^0-9]/, '')}"
    end

    # Create a binding with your Notify service
    binding = service.bindings.create(
      identity: identity,
      binding_type: binding_type,
      address: address,
      tag: tag
    )

    # Send a transactional notification to let your users know that they have
    # successfully been registered for notifications
    notification = service.notifications.create(
      body: "Great, you're signed up! I'll let you know when and where to go when it's time for the surprise.",
      identity: identity
    )
  end
end
