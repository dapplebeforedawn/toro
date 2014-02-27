#!/usr/bin/env ruby

require_relative "./drone"
require_relative "./camera"
require_relative "./colors"

DELAY_SEC = 1/15.0

Camera.go
target = Colors.new
drone  = Drone.new

loop do
  target_err = target.getMatch(Camera.get_last)
  puts target_err.y
  drone.move_to target_err.y * -1
  sleep DELAY_SEC
end
