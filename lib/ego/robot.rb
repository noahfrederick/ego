require_relative 'handler'

module Ego
  class Robot
    def respond response
      puts response
      true
    end

    def it does
      puts "*#{does}*"
      true
    end

    def continue
      false
    end
  end
end
