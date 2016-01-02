require "socket"

module Core
  class Bot
    getter bot_name,
           user_name,
           oauth_password,
           channel
    def initialize(credentials, connect : Bool)
      @bot_name, @user_name, @oauth_password, @channel = credentials
      return unless true == connect
      @cariot_return = Service::Format.break_line("")
      @channel = Service::Format.channel(@channel)
      @commander = Core::Commander.new()
      connection = TCPSocket.new("irc.twitch.tv", 6667)
      enable(connection)
      spawn start(connection)
      Signal::INT.trap do
        puts "Exiting.."
        connection.close
      end
      until connection.closed?
        buff = gets
        connection << buff.to_s if connection
      end
    end
    def enable(connection)
      send(connection, "PASS #{@oauth_password}#{@cariot_return}")
      send(connection, "NICK #{@user_name}#{@cariot_return}")
      send(connection, "USER #{@user_name}#{@cariot_return}")
      send(connection, "JOIN #{@channel}#{@cariot_return}")
    end
    def disconnect(connection)
      send(connection, "/PART #{@channel}")
    end
    def send(connection, input : String)
      connection.puts(input)
    end
    def send_private(connection, input : String)
      send(connection, "PRIVMSG #{@channel}: #{input}#{@cariot_return}")
    end
    def start(connection)
      until connection.closed?
        buf = connection.gets.try &.chomp
        next unless buf
        if buf.starts_with? "PING"
          connection.puts buf.sub("PING", "PONG") + "\r\n"
        end
        next unless buf[0] == ':'
        next unless buf.split(':').size > 2
        usernameSplit = buf.split(/[:,!]/)
        username = usernameSplit[1]
        message = buf.split(':')[2]
        @commander.handle(username, message)
      end
    end
  end
end
