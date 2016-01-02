module Service
  extend self
  module Format
    extend self
    def channel(name : String)
      if ! name.starts_with?("#")
        name ="\##{name}"
      end
      name
    end
    def break_line(input : String)
      "#{input}\n\r"
    end
  end
end
