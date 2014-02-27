require 'opencv'

# Origin is the top-left
class Colors
  include OpenCV
  SAVED_IMAGE_DIR = "images/analyzed/"

  def initialize
    template_filename = "images/red-target.jpg"
    @template = CvMat.load(template_filename)
    @sequence = 0
  end

  def get_match(filename)
    match_image     = CvMat.load(filename)
    result          = match_image.match_template(@template, :sqdiff_normed)
    cv_coords_match = result.min_max_loc[2] # magic location

    save_analyzed match_image, cv_coords_match

    half_width  = match_image.cols/2.0
    half_height = match_image.rows/2.0

    x = cv_coords_match.x - half_width
    y = half_height - cv_coords_match.y

    Target.new x/half_width, y/half_height
  end

  def save_analyzed(image, coords)
    analyzed_image = image.clone
    pt2 = CvPoint.new(coords.x + @template.width, coords.y + @template.height)
    analyzed_image.rectangle!(coords, pt2, color: CvColor::Black, thickness: 4)
    analyzed_image.save_image("#{SAVED_IMAGE_DIR}#{incr}_analyzed.jpg")
  end

  def incr
    @sequence += 1
  end

  Target = Struct.new :x, :y

end

