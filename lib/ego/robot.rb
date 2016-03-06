module Ego
  class Robot
    @@listeners = []

    def self.listen phrase, &action
      @@listeners << {
        phrase: phrase,
        action: action
      }
    end

    def respond response
      puts response
    end

    def self.interpret input
      @@listeners.each do |listener|
        listener[:action].call(Robot.new) if input.match(listener[:phrase])
      end
    end
  end
end
