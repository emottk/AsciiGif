require_relative '../config/environment'

class AsciiGif
  attr_accessor :gif, :loops, :color, :width

  def initialize(url:, loops: 2, color: true, width: 70)
    @gif = MiniMagick::Image.open(url)
    @loops = loops
    @color = color
    @width = width
  end

  def write_frames
    @gif.frames.each_with_index do |frame, idx|
      frame.write("images/frame#{idx}.jpg")
    end
    print_gif
  end

  def print_gif
    num_frames = gif.frames.count
    frames = num_frames.times.map {|f| "images/frame#{f}.jpg"}

    frames.cycle.first(num_frames * @loops).each do |frame|
       a = AsciiArt.new(frame)
       puts "\e[H\e[2J"
       puts a.to_ascii_art(color: @color, width: @width)
       sleep 0.03
    end
    delete_frames
  end

  def delete_frames
    FileUtils.rm_rf(Dir.glob('images/*'))
  end
end

attributes = {url: 'http://media.giphy.com/media/26BkN2Uh9wImWDXLa/giphy.gif', width: 100, color: true, loops: 4}
AsciiGif.new(attributes).write_frames
