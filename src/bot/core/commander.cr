module Core
  class Commander
    property queue

    def initialize
      @queue = {} of String => (String -> String)
    end

    def handle(username : String, message : String)
      input_list = message.split(' ')
      return if 0 == input_list.size
      command = input_list[0]
      return if ! @queue.has_key? "#{command}"
      args = input_list[1..(input_list.size - 1)].join()
      @queue["#{command}"].call(args)
    end

    def register(command : String, callback : (String)->String)
      @queue["#{command}"] = callback
    end
  end
end
