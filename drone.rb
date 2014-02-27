# If you don't see enough red, sit and spin.
# If you see red:
#   - try to put it in the center of your camera
#   - move forward
#
require 'socket'

class Drone
  IP      = '192.168.1.1'
  AT_PORT = 5556 #UDP, command needs to come from 5556 also.
  SCALE   = 0.7

  # AT commands at 8bit ASCII
  # One command consists in the three characters AT*
  # (i.e. three 8-bit words with values 41(16),54(16),2a(16))
  # followed by a command name, and equal sign, a sequence number,
  # and optionally a list of comma-separated arguments whose
  # meaning depends on the command.

  # T*REF         input                            Takeoff/Landing/Emergency stop command
  # AT*PCMD       flag, roll, pitch, gaz, yaw      Move the drone
  # AT*PCMD_MAG   flag, roll, pitch, gaz, yaw,     Move the drone (with Absolute Control support)
  #               psi, psi accuracy
  # AT*FTRIM      -                                Sets the reference for horizontal
  # AT*CONFIG     key, value                       Configuration of the AR.Drone 2.0
  # AT*CONFIG_IDS session, user, application ids   Identifiers for AT*CONFIG commands
  # AT*COMWDG     -                                Reset the communication watchdog
  # AT*CALIB      device number                    Calibrate the magnetometer

  def initialize
    @sequence = 1
  end

  #"0.0.0.0" will listen for all incoming hosts, probably.
  def initialize
    @socket = UDPSocket.new
    @socket.bind('0.0.0.0', AT_PORT)
  end

  # y is a float (-1..1)
  def move_to y
    Thread.new do
      @socket.send(at_command(scaled_y(y)), 0, IP, AT_PORT)
    end
  end

  def scaled_y y
    y * SCALE
  end

  def at_command drone_y
    # "AT*PCMD_MAG=#{incr},1,0,0,#{drone_y},0,0,0\n".unpack("H*")
    "AT*PCMD=#{incr},1,0,0,#{to_drone_int drone_y},0,\n".unpack("H*")
  end

  def takeoff

  end

  def to_drone_int(drone_y)
    [drone_y].pack('f').unpack('l')
  end

  def incr
    @sequence += 1
  end

end
