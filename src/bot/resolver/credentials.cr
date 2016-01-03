module Resolver
  class Credentials
    getter filename
    def initialize(filename)
      @filename = filename
    end
    def load
      contents = File.read(@filename)
      config = YAML.load(contents) as Hash(YAML::Type, YAML::Type)
      data = config[$env.to_s] as Hash(YAML::Type, YAML::Type)
      return {
        data["bot_name"] as String,
        data["user_name"] as String,
        data["oauth_password"] as String,
        data["channel"] as String
      } as Tuple
    end
  end
end
