#!/usr/bin/env ruby

require_relative "./drone"
require_relative "./camera"
require_relative "./colors"

DELAY_SEC = 1/15.0

Camera.go
target = Colors.new
drone  = Drone.new

loop do
  target_err = target.getMatch(Camera::FILE)
  drone.move_to target_err.y
  sleep DELAY_SEC
end
