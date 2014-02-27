class Camera
  IP            = Drone::IP
  VIDEO_PORT    = 5555 #TCP
  SHUTTER_SPEED = 20
  DIRECTORY = File.expand_path(File.dirname(__FILE__)) + '/images/caps/'

  def self.go
    pid = fork do
      `ffmpeg -i "tcp://#{IP}:#{VIDEO_PORT}" -r #{SHUTTER_SPEED} -f image2 #{DIRECTORY}%03d.jpg`
    end
    # Process.detach(pid)
  end

  def self.get_last
    files = Dir.new(DIRECTORY).select { |file| file!= '.' && file!='..' }
    return nil if (files.size < 1)
    files = files.collect { |file| DIRECTORY+'/'+file }
    files = files.sort { |a,b| File.mtime(b)<=>File.mtime(a) }.first
  end

end
