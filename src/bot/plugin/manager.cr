module Plugin
  class Manager < Core::Commander
    property username,
        message
    def initialize()
      super
    end
    def handle(username : String, message : String)
      @username = username
      @message = message
      return super as Tuple(String, String)
    end
    def config=(config : Array(String))
      if nil == config[0]
        path = Dir.current
      else
        path = config[0]
      end
      if nil == config[1]
        file_name = ".botrc"
      else
        file_name = config[1]
      end
      config = "#{path}/#{file_name}"
      contents = File.read(config)
      @config = YAML.load(contents)
    end
    def config()
      return (@config as Hash)
    end
    def run(args)
      before = self.execute(args, "before") if @has_before
      action = self.execute(args, "action")
      after = self.execute(args, "after") if @has_after
      return Tuple.new(before, action, after)
    end
  end
end
