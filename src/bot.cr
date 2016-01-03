require "yaml"
require "./bot/*"
require "./bot/core/*"
require "./bot/service/*"
require "./bot/resolver/*"

module Bot
  $env = :test
  if :test != $env
    credentials = Resolver::Credentials.new()
    data = credentials.load()
    bot = Core::Bot.new(data, true)
  end
end
