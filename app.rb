require 'sinatra/base'
require 'sinatra/config_file'
require 'sinatra/flash'
require 'tilt/haml'
require 'dotenv/load'

require_relative 'lib/binding_creator'

ENV['RACK_ENV'] ||= 'development'

require 'bundler'
Bundler.require :default, ENV['RACK_ENV'].to_sym

module FlashMob
  class App < Sinatra::Base
    register Sinatra::ConfigFile
    config_file 'config/app.yml'

    enable :sessions
    register Sinatra::Flash
    set :root, File.dirname(__FILE__)

    # Connect to you Notify service
    before do
      account_sid = ENV['TWILIO_ACCOUNT_SID']
      auth_token = ENV['TWILIO_AUTH_TOKEN']
      client = Twilio::REST::Client.new(account_sid, auth_token)
      @service = client.notify.v1.services(ENV['TWILIO_NOTIFY_SERVICE'])
    end

    # User-facing notification sign-up
    get '/' do
      haml :'/signup'
    end

    # Create a binding when the user successfully registers via the web or 
    # mobile app
    post '/register' do
      begin 
        BindingCreator.create_binding(
          params[:type], params[:address], params[:tag], params[:identity])
        if params[:type] == 'sms'
          redirect to('/welcome')
        end
      rescue Twilio::REST::RestError => error
        @error = error
        flash[:error] = 'Please enter a valid phone number.'
        redirect to('/')
      end
    end


    # Organizer-specific message composition 
    # (you may wish to hide this behind an auth wall to prevent users from 
    # sending messages to the group)
    get '/compose' do
      haml :'/compose'
    end

    # Send a notification to participants who registered (use the tag param to
    # determine full or segmented audience)
    post '/send_message' do
      notification = @service.notifications.create(
        body: params[:message],
        tag: params[:tag])
      redirect to('/confirmation')
    end

    # Registration confirmation page
    get '/welcome' do
      haml :'/register_confirmation'
    end

    # Message confirmation page
    get '/confirmation' do
      haml :'/send_confirmation'
    end
  end
end
