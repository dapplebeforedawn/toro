require 'opencv'

# Origin is the top-left
class Colors
  include OpenCV

  def initialize
    template_filename = "images/red-target.jpg"
    @template = CvMat.load(template_filename)
  end

  def getMatch(filename)
    match_image     = CvMat.load(filename)
    result          = match_image.match_template(@template, :sqdiff_normed)
    cv_coords_match = result.min_max_loc[2] # magic location

    half_width  = match_image.cols/2.0
    half_height = match_image.rows/2.0

    x = cv_coords_match.x - half_width
    y = half_height - cv_coords_match.y

    Target.new x/half_width, y/half_height
  end

  Target = Struct.new :x, :y

end

