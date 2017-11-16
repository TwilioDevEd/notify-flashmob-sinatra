<a href="https://www.twilio.com">
  <img src="https://static0.twilio.com/marketing/bundles/marketing/img/logos/wordmark-red.svg" alt="Twilio" width="250" />
</a>

# Multichannel Notifications with Sinatra and Twilio

## Local development

This project is built using the [Sinatra](http://www.sinatrarb.com/) web framework.

1. First clone this repository and `cd` into it.

   ```bash
   git clone git@github.com:jennifermarie/notify-flashmob-sinatra.git
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

   Run `source .env` to export the environment variables.

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

## Meta
* [MIT License](http://www.opensource.org/licenses/mit-license.html)
* Lovingly crafted by the Twilio Developer Education team ❤️