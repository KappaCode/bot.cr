module Resolver
  class Database
    getter filename
    def initialize
      @filename = "config/database.yml"
    end
    def load
      contents = File.read(@filename)
      config = YAML.load(contents) as Hash(YAML::Type, YAML::Type)
      data = config[$env.to_s] as Hash(YAML::Type, YAML::Type)
      return {
        data["database"] as Hash(YAML::Type, YAML::Type),
        data["cache"] as Hash(YAML::Type, YAML::Type)
      } as Tuple
    end
  end
end
