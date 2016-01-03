require "yaml"
require "./bot/*"
require "./bot/core/*"
require "./bot/service/*"
require "./bot/resolver/*"
require "./bot/plugin/*"


module Bot
  $env = :test
  if :test != $env
    credentials = Resolver::Credentials.new("config/credentials.yml")
    data = credentials.load()
    bot = Core::Bot.new(data, true)
  end
end
