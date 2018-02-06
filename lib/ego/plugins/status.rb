# frozen_string_literal: true

Ego.plugin do |robot|
  robot.can 'report robot status'

  robot.define_hook :on_status

  robot.on_ready do
    @startup_time = Time.now
  end

  robot.on_status do
    printf "uptime: %i seconds\n", Time.now - @startup_time
    printf "verbosity: %s\n", (verbose? ? 'verbose' : 'normal')
  end

  robot.on(/(status|diagnostic|uptime)/i => 1) do
    emote 'running self-diagnostics'
    run_hook :on_status
  end
end
