# frozen_string_literal: true

Airbrake.configure do |config|
  config.api_key = 'a6ed20b2739fb08bebecd77ae2a554bf'
  config.host    = 'errbit.genesys.shefcompsci.org.uk'
  config.port    = 443
  config.secure  = config.port == 443
end
