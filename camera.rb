class Camera
  IP            = Drone::IP
  VIDEO_PORT    = 5555 #TCP
  SHUTTER_SPEED = 20
  FILE          = File.expand_path(File.dirname(__FILE__)) + '/images/current.jpg'

  def self.go
    pid = fork do
      `ffmpeg -i "tcp://#{IP}:#{VIDEO_PORT}" -r #{SHUTTER_SPEED} -f image2 #{FILE}`
    end
    Process.detach(pid)
  end

end
