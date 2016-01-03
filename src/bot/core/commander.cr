module Core
  class Command
    property name,
        state,
        callback
    def initialize(name, state, callback)
      @name = name
      @state = state
      @callback = callback
    end
  end
  class Commander
    property queue,
        has_after,
        has_before
    def initialize
      @has_before = false
      @has_after = false
      @queue = [] of Core::Command
    end
    def handle(username : String, message : String)
      input_list = message.split(' ')
      return if 0 == input_list.size
      command = input_list[0]
      return if ! has_command? "#{command}"
      args = input_list[1..(input_list.size - 1)].join()
      return Tuple.new("#{command}", "#{args}")
    end
    def register(command : String,
                 state : String,
                 callback : String -> String)
      command = Command.new(command, state, callback)
      @has_before = true if "before" == state
      @has_after = true if "after" == state
      @queue.push(command)
    end
    def execute(command : Tuple(String, String), state)
      callback = invoke_command(command[0], state).first().callback
      callback.call(command[1])
    end
    def execute(command, args, state)
      callback = invoke_command(command, state).first().callback
      callback.call(args)
    end
    def has_command?(name : String)
      return false unless 0 != @queue.size
      return 0 != @queue.select { |item| item.name == name} .size
    end
    def invoke_command(name : String, state)
      return @queue.select { |item| item.name == name && item.state == state}
    end
  end
end
