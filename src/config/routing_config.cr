require "./cors_config"

# Encompasses all configuration related to the `Athena::Routing` component.
#
# For a higher level introduction to configuring Athena components, see `Athena::Config`.
struct Athena::Routing::Config
  include ACF::Configuration

  # Configuration related to `ART::Listeners::CORS`.
  #
  # Disables the listener if not defined.
  getter cors : ART::Config::CORS? = nil

  # Configuration related to `ART::Listeners::Format`.
  #
  # Disables the listener if not defined.
  getter content_negotiation : ART::Config::ContentNegotiation? = nil
end

struct Athena::Config::Base
  # All configuration related to the `ART` component.
  getter routing : Athena::Routing::Config = Athena::Routing::Config.new
end
