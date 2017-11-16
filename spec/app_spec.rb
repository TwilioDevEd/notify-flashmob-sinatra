ENV['RACK_ENV'] = 'test'
require_relative '../app'
require 'rspec'
require 'rack/test'
require 'json'
require 'webmock/rspec'
WebMock.disable_net_connect!(allow_localhost: true)

RSpec.configure do |config|
  config.before(:each) do
      stub_request(:post, "https://notify.twilio.com/v1/Services/#{ENV['TWILIO_NOTIFY_SERVICE']}/Bindings").
         with(body: {"Address"=>"+13125339189", "BindingType"=>"sms", "Identity"=>"user1", "Tag"=>"sms-participant"},
              headers: {'Accept'=>'application/json', 'Accept-Charset'=>'utf-8', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Basic QUM5OWJhN2I2MWZiZGI2YzAzOTY5ODUwNWRlYTVmMDQ0YzpmNTZmN2Q4MTcwYWRmZjYzMjk4NzBmODc2MTI5OTNlNA==', 'Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=>'twilio-ruby/5.3.1 (ruby/x86_64-darwin16 2.4.1-p111)'}).
         to_return(status: 200, body: "", headers: {}) 
      stub_request(:post, "https://notify.twilio.com/v1/Services/#{ENV['TWILIO_NOTIFY_SERVICE']}/Notifications").
         with(body: {"Body"=>"Great, you're signed up! I'll let you know when and where to go when it's time for the surprise.", "Identity"=>"user1"},
              headers: {'Accept'=>'application/json', 'Accept-Charset'=>'utf-8', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Basic QUM5OWJhN2I2MWZiZGI2YzAzOTY5ODUwNWRlYTVmMDQ0YzpmNTZmN2Q4MTcwYWRmZjYzMjk4NzBmODc2MTI5OTNlNA==', 'Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=>'twilio-ruby/5.3.1 (ruby/x86_64-darwin16 2.4.1-p111)'}).
         to_return(status: 200, body: "", headers: {})
      stub_request(:post, "https://notify.twilio.com/v1/Services/#{ENV['TWILIO_NOTIFY_SERVICE']}/Notifications").
         with(body: {"Body"=>"It's party time!", "Tag"=>"all"},
              headers: {'Accept'=>'application/json', 'Accept-Charset'=>'utf-8', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Basic QUM5OWJhN2I2MWZiZGI2YzAzOTY5ODUwNWRlYTVmMDQ0YzpmNTZmN2Q4MTcwYWRmZjYzMjk4NzBmODc2MTI5OTNlNA==', 'Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=>'twilio-ruby/5.3.1 (ruby/x86_64-darwin16 2.4.1-p111)'}).
         to_return(status: 200, body: "", headers: {})
      stub_request(:post, "https://notify.twilio.com/v1/Services/#{ENV['TWILIO_NOTIFY_SERVICE']}/Bindings").
         with(body: {"Address"=>"+1", "BindingType"=>"sms", "Identity"=>"user1", "Tag"=>"sms-participant"},
              headers: {'Accept'=>'application/json', 'Accept-Charset'=>'utf-8', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Basic QUM5OWJhN2I2MWZiZGI2YzAzOTY5ODUwNWRlYTVmMDQ0YzpmNTZmN2Q4MTcwYWRmZjYzMjk4NzBmODc2MTI5OTNlNA==', 'Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=>'twilio-ruby/5.3.1 (ruby/x86_64-darwin16 2.4.1-p111)'}).
         to_return(status: 200, body: "", headers: {})   
  end
end

describe 'flashmob notifications' do
  include Rack::Test::Methods

  def app
    FlashMob::App
  end

  it 'shows signup page when root URL is accessed' do
    get '/'
    expect(last_response).to be_ok
    expect(last_response.body).to include "Thanks for your interest in signing up!"
  end

  it 'errors when non-phone numbers try to register for notifications' do
    post '/register', { address: "my phone number", type: "sms", 
      tag: "sms-participant", identity: "user1"}
    expect(last_response).to_not be_ok
  end

  it 'redirects to /welcome after creating a binding' do
    post '/register', { address: "+13125339189", type: "sms", 
      tag: "sms-participant", identity: "user1"}
    expect(last_response).to be_redirect
    follow_redirect!
    expect(last_request.url).to include '/welcome'
  end

  it 'redirects to /confirmation after sending a message' do
    post '/send_message', { message: "It's party time!", tag: "all" }
    expect(last_response).to be_redirect
    follow_redirect!
    expect(last_request.url).to include '/confirmation'
  end
end