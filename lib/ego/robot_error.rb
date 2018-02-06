# frozen_string_literal: true

module Ego
  # Error type raised by robot plug-in DSL.
  #
  # `RobotError`s print their message to STDERR and halt execution of the
  # program.
  class RobotError < RuntimeError
  end
end
