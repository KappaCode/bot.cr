require "./spec_helper"

Spec2.describe Bot do
  describe "$env" do
    it "should have an environment variable" do
      expect($env).to be_a(Symbol)
    end
  end
  describe Core do
    describe Core::Bot do
      @@credential_list = {"bot_name", "user_name", "oauth_pwd", "channel"}
      subject { Core::Bot.new(@@credential_list, false)}
      it "#initialize" do
        expect(subject.bot_name).to eq("bot_name")
        expect(subject.user_name).to eq("user_name")
        expect(subject.oauth_password).to eq("oauth_pwd")
        expect(subject.channel).to eq("channel")
      end
      # it "#initialize with connect" do
      # subject = Core::Bot.new(@@credential_list, true)
      # end
    end
    describe Core::Commander do
      subject { Core::Commander.new()}
      @@adverb = -> (a : String) { "a #{a}" }
      it "#initialize" do
        expect(subject.queue).to be_truthy
      end
      it "#register" do
        subject.register("adverb", "before", @@adverb)
        expect(subject.queue.first()).to be_a(Core::Command)
      end
      it "#handle" do
        subject.register("adverb", "before", @@adverb)
        result = subject.handle("user", "adverb b")
        expect(result).to be_a(Tuple(String, String))
      end
      it "#execute" do
        subject.register("adverb", "before", @@adverb)
        handler = subject.handle("user", "adverb b")
        result = subject.execute(
                                 handler as Tuple(String, String),
                                 "before")
        expect(result).to eq("a b")
      end
    end
  end
  describe Service do
    describe Service::Format do
      it "#channel" do
        channel_names = [] of String
        channel_names = ["name", "#name"]
        channel_names.each  do |name|
          name = Service::Format.channel(name)
          expect(name).to match(/^\#{1}/)
        end
      end
      it "#break_line" do
        input = "input" as String
        input = Service::Format.break_line(input)
        expect(input).to match(/[\r|\n]$/)
      end
    end
  end
  describe Resolver do
    describe Resolver::Credentials do
      subject { Resolver::Credentials.new("./.config/credentials.yml")}
      it "#initalize" do
        expect(subject.filename).to be_a(String)
      end
      it "#load" do
        data = subject.load()
        expect(data).to be_a(Tuple(String, String, String, String))
      end
    end
    describe Resolver::Database do
      subject {Resolver::Database.new("./.config/database.yml")}
      it "#initialize" do
        expect(subject.filename).to be_a(String)
      end
      it "#load" do
        data = subject.load()
        expect(data[0]).to be_a(Hash(YAML::Type, YAML::Type))
        expect(data[1]).to be_a(Hash(YAML::Type, YAML::Type))
      end
    end
  end
  describe Plugin do
    describe Plugin::Manager do
      describe "procedural" do
        subject {Plugin::Manager.new()}
        @@prefix = -> (a : String) { "< #{a}" }
        @@suffix = -> (a : String) { "#{a} >"}
        @@action = -> (a : String) {"-#{a}-"}
        it "#initialize" do
          expect(subject.has_before).to be_false
          expect(subject.has_after).to be_false
        end
        it "#handle" do
          subject.register("adverb", "before", @@prefix)
          handler = subject.handle("user", "adverb b")
          expect(subject.username).to be_a(String)
          expect(subject.message).to be_a(String)
        end
        it "::config" do
          File.write("./.config/config.yml", "name: \"hello\"")
          subject.config = [".config", "config.yml"]
          expect(subject.config["name"]).to be_a(String)
        end
        it "#run" do
          arg = "arguments"
          subject.register("adverb", "before", @@prefix)
          subject.register("adverb", "action", @@action)
          subject.register("adverb", "after", @@suffix)
          handler = subject.handle("user", "adverb #{arg}")
          result = subject.run(handler)
          expect(result).to eq({
                                 "< arguments",
                                 "-arguments-",
                                 "arguments >"
                               })
        end
      end
      # describe "object oriented" do
      #   subject {Plugin::Manager.new()}
      # end
    end
  end
end
