#!/usr/bin/env ruby

require_relative "./drone"
require_relative "./camera"
require_relative "./colors"

DELAY_SEC = 1/15.0
LOG_FILE  = "log.dat"

Camera.go
target = Colors.new
drone  = Drone.new
log    = File.open(LOG_FILE, 'w')

puts "--------- Starting ----------"
loop do
  target_err = target.get_match(Camera.get_last)
  log << target_err.y
  drone.move_to target_err.y * -1
  sleep DELAY_SEC
end
