module Plugin
  class Manager < Commander
    property username,
        message,
        config,
        command
    def initialize(command)
      super
      @command = command
      @has_before = false
      @has_after = false
    end
    def handle(username : String, message : String)
      super
      @username = username
      @message = message
    end
    def config=(path : String, file_name : String)
      if nil == path
        path = Dir.current
      end
      if nil == file_name
        file_name = ".botrc"
      end
      @config = "#{path}/#{filename}"
    end
    def run()
      if false == @has_before
        @execute(@queue[@command][0])
      end
      @execute(@queue[@commands][1])
      if false == @has_after
        @execute(@queue[@command][2])
      end
    end
    def before(callback: -> (String, String), args)
      @register(@command, 0, callback, args)
      @has_before = true
    end
    def action(callback: ->(String, String), args)
      @register(@command, 1, callback, args)
    end
    def after(callback: -> (String, String), args)
      @register(@command, 2, callback, args)
      @has_after = true
    end
  end
end
