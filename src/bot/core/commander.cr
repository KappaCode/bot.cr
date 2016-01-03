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
    property queue
    def initialize
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
    def register(
                 command : String,
                 state : Int32,
                 callback : String -> String)
      command = Command.new(command, state, callback)
      @queue.push(command)
    end
    def execute(command : Tuple(String, String), state)
      callback = invoke_command(command[0], state).first().callback
      callback.call(command[1])
    end
    def execute(command, args, state=0)
      callback = invoke_command(command, state).first().callback
      callback.call(args)
    end
    def has_command?(name)
      return false unless 0 != @queue.size
      return 0 != @queue.select { |item| item.name == name} .size
    end
    def invoke_command(name, state)
      return @queue.select { |item| item.name == name && item.state == state}
    end
  end
end
