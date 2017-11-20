<a href="https://www.twilio.com">
  <img src="https://static0.twilio.com/marketing/bundles/marketing/img/logos/wordmark-red.svg" alt="Twilio" width="250" />
</a>

# Multichannel Notifications with Sinatra and Twilio

This project is built using the [Sinatra](http://www.sinatrarb.com/) web framework. It is designed to allow users to subscribe to and send SMS notifications via Twilio Notify, and is the companion app to [Multichannel Notifications with Swift and Twilio](https://github.com/TwilioDevEd/notify-flashmob-swift/), which allows users to subscribe to native Apple push notifications (APN). 

## Local development

1. First clone this repository and `cd` into it.

   ```bash
   git clone git@github.com:TwilioDevEd/notify-flashmob-sinatra.git
   cd notify-flashmob-sinatra
   ```

1. Install the dependencies.

   ```bash
   bundle install
   ```

1. Copy the sample configuration file and edit it to match your configuration.

   ```bash
   cp .env.example .env
   ```

   You can find your `TWILIO_ACCOUNT_SID` and `TWILIO_AUTH_TOKEN` in your
   [Twilio Account Settings](https://www.twilio.com/user/account/settings).
   You will also need to set up a `TWILIO_NOTIFY_SERVICE` [here](https://www.twilio.com/console/notify/services) and if you have not yet registered for one, you'll need to set up a Twilio phone number [here](https://www.twilio.com/user/account/phone-numbers/incoming) and Messaging Service [here](https://www.twilio.com/console/sms/services).


1. Make sure the tests succeed.

   ```bash
   bundle exec rspec
   ```

1. Start the server.

   ```bash
   bundle exec rackup
   ```

1. Check it out at [http://localhost:9292](http://localhost:9292).

1. Expose the application to the wider internet so you can access it via mobile web or the companion iOS app.

   We can use [ngrok](https://ngrok.com/) for this purpose.

   ```bash
   ngrok http 9292
   ```

## Register for notifications

Navigate to `/` on web or mobile to register for SMS notifications. Enter a valid phone number, and you should be able to create a binding to that number (you'll then be able to receive notifications via Twilio Notify). 

_Note: as-is, this application expects US phone numbers; you'll need to edit binding_creator.rb to remove the +1 from entered addresses if you are outside of the US, and trade it for your country code._

## Compose a notification

Navigate to `/compose` to draft a notification, and tap the button on the left to send it to all registered users. 

If you have users who have registered for Apple Push Notifications via the [companion Swift app](https://github.com/TwilioDevEd/notify-flashmob-swift/), you may send segmented notifications to SMS and iOS users.

_Note: in a production application, the `/compose` endpoint would likely be inaccessible to users. It is exposed here to allow easy notification composition._

## Meta
* [MIT License](http://www.opensource.org/licenses/mit-license.html)
* Lovingly crafted by the Twilio Developer Education team ❤️
