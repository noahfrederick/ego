Ego::Handler.register do |handler|
  handler.description = 'repeat what you say'

  handler.listen /^(?:say|echo)\s+(?<input>.+)/i, priority: 6

  handler.run do |robot, params|
    robot.debug params
    # robot.respond params[:input]
  end
end
