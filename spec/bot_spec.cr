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
      it "#initialize with connect" do
        subject = Core::Bot.new(@@credential_list, true)
        has_started = subject.start()
      end
    end
    describe Core::Commander do
      subject { Core::Commander.new()}
      @@adverb = -> (a : String) { "a #{a}" }
      before{subject.register("adverb", @@adverb)}
      it "#initialize" do
        expect(subject.queue).to be_truthy
      end
      it "#register" do
        result = subject.queue["adverb"].call("b")
        expect(result).to eq("a b")
      end
      it "#handle" do
        result = subject.handle("user", "adverb b")
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
      subject { Resolver::Credentials.new()}
      it "#initalize" do
        expect(subject.filename).to be_a(String)
      end
      it "#load" do
        data = subject.load()
        expect(data).to be_a(Tuple(String, String, String, String))
      end
    end
    describe Resolver::Database do
      subject {Resolver::Database.new}
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
end
