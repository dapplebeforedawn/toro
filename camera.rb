class Camera
  IP            = Drone::IP
  VIDEO_PORT    = 5555 #TCP
  SHUTTER_SPEED = 20
  DIRECTORY = "images/caps/"
  READ_SIZE = 1024
  DONE_MATCH = /frame=/
  #  Stream mapping:
  #    Stream #0:0 -> #0:0 (mpeg4 -> libx264)
  #Press [q] to stop, [?] for help
  #  frame=  112 fps= 52 q=32766.0 Lsize=     408kB time=00:00:04.58 bitrate= 729.7kbits/s

  def self.go
    pipe = IO.popen "ffmpeg -i \"tcp://#{IP}:#{VIDEO_PORT}\" -r #{SHUTTER_SPEED} -f image2 #{DIRECTORY}%03d.jpg"
    block_until_ready(pipe)
  end

  def self.get_last
    Dir.new(DIRECTORY)
      .select  { |file| file!= '.' && file!='..' }
      .collect { |file| "#{DIRECTORY}/#{file}" }
      .sort    { |a,b| File.mtime(b)<=>File.mtime(a) }
      .first
  end

  def self.block_until_ready(pipe)
    loop do
      reads = pipe.readpartial(READ_SIZE)
      break if reads =~ DONE_MATCH
    end
  end

end
